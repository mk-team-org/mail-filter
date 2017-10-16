class UploadedFile < ApplicationRecord
  mount_uploader :emails_file, EmailsFileUploader
end
