require 'csv'

class MailsProcessorController < ApplicationController
  EMAIL_SLICE_SIZE = Rails.env.development? ? 10 : 1000

  def home
  end

  def import
    CSV.foreach(params[:file][:data].path, headers: false).each_slice(EMAIL_SLICE_SIZE) do |csv|
      new_emails = csv.flatten
      existing_emails = Contact.where(email: new_emails).pluck(:email)
      email_attrs = (new_emails - existing_emails).map{|e| {email: e}}
      Contact.bulk_insert(values: email_attrs)
    end

    redirect_to root_path
  end

  def angry
    CSV.foreach(params[:file][:data].path, headers: false).each_slice(EMAIL_SLICE_SIZE) do |csv|
      Contact.where(email: csv.flatten).update_all(angry: true)
    end

    redirect_to root_path
  end

  def exclude
    CSV.foreach(params[:file][:data].path, headers: false).each_slice(EMAIL_SLICE_SIZE) do |csv|
      Contact.where(email: csv.flatten).update_all(excluded: true)
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
