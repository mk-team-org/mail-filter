class ImportMailWorker
  include Sidekiq::Worker

  def perform(emails)
    existing_emails = Contact.where(email: emails).pluck(:email)
    email_attrs = (emails - existing_emails).map{|e| {email: e}}
    Contact.bulk_insert(values: email_attrs)
  end
end
