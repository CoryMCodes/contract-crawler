class FetchSourceJob
  include Sidekiq::Job

  sidekiq_options queue: :crawlers, retry: 3

  def perform(source_id)
    SourceSyncJob.new.perform(source_id)
  end
end
