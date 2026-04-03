module SourceIngestion
  class SyncSource
    def initialize(source:)
      @source = source
    end

    def call
      crawler.fetch.each do |raw_payload|
        source_record = persist_source_record(raw_payload)
        normalized_attributes = normalize_payload(raw_payload)
        buyer = upsert_buyer(normalized_attributes)
        upsert_opportunity(source_record:, buyer:, normalized_attributes:)
        source_record.update!(status: "normalized")
      end

      source.update!(last_synced_at: Time.current)
    end

    private

    attr_reader :source

    def crawler
      @crawler ||= Crawlers::Registry.build(source)
    end

    def persist_source_record(raw_payload)
      source_record = source.source_records.find_or_initialize_by(
        fingerprint: crawler.fingerprint(raw_payload)
      )

      source_record.assign_attributes(
        external_id: crawler.external_id(raw_payload),
        raw_payload: raw_payload,
        raw_body: raw_payload.is_a?(String) ? raw_payload : Oj.dump(raw_payload),
        fetched_at: source_record.fetched_at || Time.current,
        parser_version: "v1",
        status: "fetched"
      )
      source_record.save!
      source_record
    end

    def normalize_payload(raw_payload)
      parsed_attributes = crawler.parse(raw_payload)
      Normalization::OpportunityNormalizer.new(source:, attributes: parsed_attributes).call
    end

    def upsert_buyer(normalized_attributes)
      buyer_name = normalized_attributes[:buyer_name].presence || "Unknown Buyer"
      buyer = Buyer.find_or_initialize_by(name: buyer_name)
      buyer.assign_attributes(
        state: normalized_attributes[:state],
        city: normalized_attributes[:city],
        source_identifier: buyer.source_identifier.presence || buyer_name.parameterize
      )
      buyer.save!
      buyer
    end

    def upsert_opportunity(source_record:, buyer:, normalized_attributes:)
      opportunity = Opportunity.find_or_initialize_by(
        source:,
        external_id: normalized_attributes.fetch(:external_id)
      )
      opportunity.assign_attributes(normalized_attributes.except(:external_id, :attachments, :award))
      opportunity.source_record = source_record
      opportunity.buyer = buyer
      opportunity.source = source
      opportunity.save!
      sync_attachments(opportunity:, attachments: normalized_attributes[:attachments])
      sync_award(opportunity:, award_attributes: normalized_attributes[:award])
      opportunity
    end

    def sync_attachments(opportunity:, attachments:)
      return if attachments.blank?

      existing_file_urls = attachments.map { |attachment| attachment.fetch(:file_url) }
      opportunity.attachments.where.not(file_url: existing_file_urls).delete_all

      attachments.each do |attachment_attributes|
        attachment = opportunity.attachments.find_or_initialize_by(
          file_url: attachment_attributes.fetch(:file_url)
        )
        attachment.assign_attributes(attachment_attributes)
        attachment.save!
      end
    end

    def sync_award(opportunity:, award_attributes:)
      return if award_attributes.blank?

      award = opportunity.awards.find_or_initialize_by(
        award_number: award_attributes[:award_number].presence || "source-award"
      )
      award.assign_attributes(award_attributes)
      award.save!
    end
  end
end
