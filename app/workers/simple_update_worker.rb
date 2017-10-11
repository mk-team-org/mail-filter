class SimpleUpdateWorker
  include Sidekiq::Worker

  def perform(emails, clause)
    Contact.where(email: emails).in_batches.each { |cs| cs.update_all(clause) }
  end
end
