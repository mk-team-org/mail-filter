require 'csv'

class MailsProcessorController < ApplicationController
  EMAIL_SLICE_SIZE = Rails.env.development? ? 10 : 1000

  def home
  end

  def import
    # CSV.foreach(params[:contact][:file_data].path, headers: false).each_slice(EMAIL_SLICE_SIZE) do |csv|
    IO.readlines(params[:contact][:file_data].path).each_slice(EMAIL_SLICE_SIZE) do |lines|
      new_emails = lines.map do |line|
        ActiveSupport::Inflector.transliterate(line).strip
      end.reject(&:blank?)
      existing_emails = Contact.where(email: new_emails).pluck(:email)
      email_attrs = (new_emails - existing_emails).map{|e| {email: e}}
      Contact.bulk_insert(values: email_attrs)
    end

    redirect_to root_path
  end

  def angry
    IO.readlines(params[:contact][:file_data].path).each_slice(EMAIL_SLICE_SIZE) do |lines|
      emails = lines.map do |line|
        ActiveSupport::Inflector.transliterate(line).strip
      end.reject(&:blank?)
      Contact.where(email: emails).update_all(angry: true)
    end

    redirect_to root_path
  end

  def exclude
    IO.readlines(params[:contact][:file_data].path).each_slice(EMAIL_SLICE_SIZE) do |lines|
      emails = lines.map do |line|
        ActiveSupport::Inflector.transliterate(line).strip
      end.reject(&:blank?)
      Contact.where(email: emails).update_all(excluded: true)
    end

    redirect_to root_path
  end

  def download
    csv_string = CSV.generate do |csv|
      Contact.where(angry: false, excluded: false).find_each do |contact|
        csv << [contact.email]
      end
    end
    filename = Time.now.strftime("emails_%Y_%m_%d_%H_%M_%S.csv")

    send_data csv_string, filename: filename, disposition: 'inline'
  end
end
