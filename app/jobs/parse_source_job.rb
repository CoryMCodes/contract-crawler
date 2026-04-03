class ParseSourceJob
  include Sidekiq::Job

  sidekiq_options queue: :crawlers, retry: 3

  def perform(source_record_id)
    SourceRecord.find(source_record_id).update!(status: "parsed")
  end
end
