class EnrichSourceJob
  include Sidekiq::Job

  sidekiq_options queue: :enrichment, retry: 3

  def perform(source_record_id)
    SourceRecord.find(source_record_id).update!(status: "enriched")
  end
end
