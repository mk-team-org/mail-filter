require 'csv'
require 'sidekiq/api'

class MailsProcessorController < ApplicationController
  before_action :authenticate_user!

  def home
    @import_size = Sidekiq::Queue.new.size + Sidekiq::RetrySet.new.size + Sidekiq::ScheduledSet.new.size + Sidekiq::ProcessSet.new.map{|x| x['busy']}.sum
    @import_in_progress = @import_size.nonzero?
  end

  def import
    process_uploaded_file('import')

    redirect_to root_path
  end

  def angry
    process_uploaded_file('angry')

    redirect_to root_path
  end

  def exclude
    process_uploaded_file('exclude')

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

  def contact_params
    params.require(:contact).permit(file_data: [])
  end

  def process_uploaded_file(process_type)
    contact_params[:file_data].each do |file_data|
      up_file = UploadedFile.create(emails_file: file_data)
      ProcessFileWorker.perform_async(up_file.id, process_type)
    end
  end
end
