require 'csv'
require 'sidekiq/api'

class MailsProcessorController < ApplicationController
  before_action :authenticate_user!
  EMAIL_SLICE_SIZE = Rails.env.development? ? 10 : 1000

  def home
    @import_size = Sidekiq::Queue.new.size + Sidekiq::RetrySet.new.size + Sidekiq::ScheduledSet.new.size
    @import_in_progress = @import_size.nonzero?
  end

  def import
    # CSV.foreach(params[:contact][:file_data].path, headers: false).each_slice(EMAIL_SLICE_SIZE) do |csv|
    IO.readlines(params[:contact][:file_data].path).each_slice(EMAIL_SLICE_SIZE) do |lines|
      new_emails = lines.map do |email|
        ActiveSupport::Inflector.transliterate(email).strip.downcase
      end.reject(&:blank?)

      ImportMailWorker.perform_async(new_emails)
    end

    redirect_to root_path
  end

  def angry
    IO.readlines(params[:contact][:file_data].path).each_slice(EMAIL_SLICE_SIZE) do |lines|
      emails = lines.map do |line|
        ActiveSupport::Inflector.transliterate(line).strip.downcase
      end.reject(&:blank?)
      Contact.where(email: emails).update_all(angry: true)
    end

    redirect_to root_path
  end

  def exclude
    IO.readlines(params[:contact][:file_data].path).each_slice(EMAIL_SLICE_SIZE) do |lines|
      emails = lines.map do |line|
        ActiveSupport::Inflector.transliterate(line).strip.downcase
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
