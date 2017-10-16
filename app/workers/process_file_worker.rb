class ProcessFileWorker
  include Sidekiq::Worker
  EMAIL_SLICE_SIZE = Rails.env.development? ? 10 : 5000

  def perform(up_file_id, process_type)
    up_file = UploadedFile.find(up_file_id)
    work_arr = []
    up_file.emails_file.file.to_file.each_line do |line|
      email = ActiveSupport::Inflector.transliterate(line).strip.downcase
      next if email.blank?
      work_arr << email
      if work_arr.size >= EMAIL_SLICE_SIZE
        if process_type == 'import'
          ImportMailWorker.perform_async(work_arr)
        elsif process_type == 'angry'
          SimpleUpdateWorker.perform_async(work_arr, angry: true)
        elsif process_type == 'exclude'
          SimpleUpdateWorker.perform_async(work_arr, excluded: true)
        end
        work_arr = []
      end
    end
    up_file.update_attribute(:processed, true)
  end
end
