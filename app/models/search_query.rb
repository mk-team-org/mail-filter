class SearchQuery < ApplicationRecord
  attr_accessor :valid_emails

  validates :first_name, :last_name, :nip, :domain, presence: true
  validates :nip, uniqueness: {scope: [:first_name, :last_name]}
  before_validation :downcase_params

  def status
    return "Catch all" if catch_all
    return cant_check if cant_check
    return "Completed" if completed
    return "In progress" if in_progress
    return "Queued"
  end

  def perform_dns_check!
    update_attribute(:in_progress, true)
    check_for_catch_all
    perform_main_check unless catch_all || completed
  end

  def downcase_params
    self.first_name = self.first_name.downcase
    self.last_name = self.last_name.downcase
    self.domain = self.domain.downcase
    true
  end

  def possible_emails
    return @possible_emails if @possible_emails.present?

    fnames = [first_name, first_name[0]]
    lnames = [last_name, last_name[0]]
    combos = 
      fnames.flat_map do |fname|
        lnames.flat_map do |lname|
          combinations = [
            [fname, lname].join,
            [lname, fname].join
          ]
          if fname.size > 1 or lname.size > 1
            combinations += [
              [fname, lname].join('.'),
              [fname, lname].join('-'),
              [lname, fname].join('.'),
              [lname, fname].join('-')
            ]
          end
          combinations
        end
      end
    combos += fnames
    combos << last_name
    combos << "#{first_name[0..2]}#{last_name[0..2]}"
    combos << "#{last_name[0..2]}#{first_name[0..2]}"

    @possible_emails = combos.shuffle.map {|combo| "#{combo}@#{domain}"}
  end

  def check_for_catch_all
    update_attributes(catch_all: true, completed: true) if EmailVerifier.check("rlyrlyanythin@#{domain}")
  rescue Exception => e
    update_attributes(cant_check: e.message, completed: true)
  end

  def perform_main_check
    (possible_emails - tested_emails).each do |email|
      begin
        update_attribute(:emails, emails.push(email)) if EmailVerifier.check(email)
      rescue
        nil
      end
      update_attribute(:tested_emails, tested_emails.push(email))
      sleep 5
    end
    update_attribute(:completed, true)
  end
end
