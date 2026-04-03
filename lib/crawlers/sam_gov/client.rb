module Crawlers
  module SamGov
    class Client
      class ConfigurationError < StandardError; end

      DEFAULT_BASE_URL = "https://api.sam.gov".freeze
      DEFAULT_LIMIT = 100
      DEFAULT_POSTED_DAYS_BACK = 30

      def initialize(source:)
        @source = source
      end

      def fetch
        raise ConfigurationError, "SAM_GOV_API_KEY is required to fetch opportunities" if api_key.blank?

        payloads = []
        offset = 0

        loop do
          response_payload = request_page(offset:)
          batch = Array(response_payload["opportunitiesData"])
          payloads.concat(batch)

          total_records = response_payload["totalRecords"].to_i
          break if batch.empty?

          offset += limit
          break if offset >= total_records
        end

        payloads
      end

      private

      attr_reader :source

      def request_page(offset:)
        response = connection.get("/opportunities/v2/search") do |request|
          request.params = query_params(offset:)
        end

        return { "opportunitiesData" => [], "totalRecords" => 0 } if response.status == 404

        Oj.load(response.body)
      end

      def query_params(offset:)
        {
          api_key: api_key,
          postedFrom: posted_from.strftime("%m/%d/%Y"),
          postedTo: posted_to.strftime("%m/%d/%Y"),
          limit: limit,
          offset:
        }.tap do |params|
          params[:ptype] = source_settings["ptype"] if source_settings["ptype"].present?
        end
      end

      def connection
        @connection ||= Faraday.new(url: base_url) do |faraday|
          faraday.adapter Faraday.default_adapter
        end
      end

      def base_url
        source_settings["base_url"].presence || ENV.fetch("SAM_GOV_API_BASE_URL", DEFAULT_BASE_URL)
      end

      def api_key
        source_settings["api_key"].presence || ENV["SAM_GOV_API_KEY"]
      end

      def limit
        @limit ||= source_settings.fetch("limit", DEFAULT_LIMIT).to_i
      end

      def posted_from
        posted_to.advance(days: -posted_days_back)
      end

      def posted_to
        @posted_to ||= Date.current
      end

      def posted_days_back
        source_settings.fetch("posted_days_back", DEFAULT_POSTED_DAYS_BACK).to_i
      end

      def source_settings
        @source_settings ||= source.settings.stringify_keys
      end
    end
  end
end
