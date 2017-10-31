class EmailCheckWorker
  include Sidekiq::Worker

  sidekiq_options :retry => 5

  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40, 50)
  end

  sidekiq_retries_exhausted do |msg, e|
    SearchQuery.find(msg['args'].first).update_attributes(completed: true, cant_check: msg['error_message'])
  end

  def perform(sq_id)
    @sq = SearchQuery.find(sq_id)
    @sq.perform_dns_check!
  ensure
    @sq.update_attribute(:in_progress, false)
  end
end
