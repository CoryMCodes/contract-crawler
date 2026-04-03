module Normalization
  class OpportunityNormalizer
    SET_ASIDE_MAP = {
      /small/i => "small_business",
      /8\(a\)/i => "8a",
      /woman/i => "woman_owned",
      /service disabled/i => "sdvosb"
    }.freeze

    STATUS_MAP = {
      "published" => "open",
      "open" => "open",
      "active" => "open",
      "yes" => "open",
      "closed" => "closed",
      "no" => "closed",
      "cancelled" => "cancelled",
      "canceled" => "cancelled",
      "archived" => "closed"
    }.freeze

    def initialize(source:, attributes:)
      @source = source
      @attributes = attributes.symbolize_keys
    end

    def call
      {
        external_id: attributes.fetch(:external_id),
        title: attributes.fetch(:title),
        description: attributes[:description],
        buyer_name: attributes[:buyer_name],
        state: normalize_state(attributes[:state]),
        city: attributes[:city],
        source_name: source.name,
        source_url: attributes[:source_url],
        solicitation_number: attributes[:solicitation_number],
        category: normalize_token(attributes[:category]),
        due_date: attributes[:due_date],
        posted_at: attributes[:posted_at],
        contract_type: normalize_token(attributes[:contract_type]),
        set_aside: normalize_set_aside(attributes[:set_aside]),
        estimated_value_low: attributes[:estimated_value_low],
        estimated_value_high: attributes[:estimated_value_high],
        naics_codes: Array(attributes[:naics_codes]).compact_blank,
        status: normalize_status(attributes[:status]),
        raw_text: attributes[:raw_text].presence || [attributes[:title], attributes[:description]].compact.join(" "),
        summary_ai: attributes[:summary_ai],
        attachments: Array(attributes[:attachments]),
        award: attributes[:award]
      }
    end

    private

    attr_reader :attributes, :source

    def normalize_state(value)
      value.to_s.upcase.presence
    end

    def normalize_set_aside(value)
      return if value.blank?

      mapping = SET_ASIDE_MAP.find { |pattern, _normalized| pattern.match?(value.to_s) }
      mapping&.last || normalize_token(value)
    end

    def normalize_status(value)
      return "open" if value.blank?

      STATUS_MAP.fetch(value.to_s.downcase, normalize_token(value))
    end

    def normalize_token(value)
      value.to_s.parameterize(separator: "_").presence
    end
  end
end
