class DedupeSourceJob
  include Sidekiq::Job

  sidekiq_options queue: :crawlers, retry: 3

  def perform(_opportunity_id)
    true
  end
end
