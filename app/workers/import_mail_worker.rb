class ImportMailWorker
  include Sidekiq::Worker

  def perform(emails)
    new_emails = emails.map do |email|
      ActiveSupport::Inflector.transliterate(email).strip
    end.reject(&:blank?)
    existing_emails = Contact.where(email: new_emails).pluck(:email)
    email_attrs = (new_emails - existing_emails).map{|e| {email: e}}
    Contact.bulk_insert(values: email_attrs)
  end
end
