class SourceSyncJob
  include Sidekiq::Job

  sidekiq_options queue: :crawlers, retry: 3

  def perform(source_id)
    source = Source.find(source_id)
    SourceIngestion::SyncSource.new(source:).call
  end
end
