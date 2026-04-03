module Crawlers
  module Usaspending
    class Parser
      def initialize(source:)
        @source = source
      end

      def parse(raw_payload)
        payload = raw_payload.deep_symbolize_keys
        {
          external_id: payload[:award_id] || payload[:external_id],
          title: payload[:award_description] || payload[:title],
          description: payload[:award_description] || payload[:description],
          buyer_name: payload[:awarding_agency_name],
          state: payload[:place_of_performance_state_code],
          city: payload[:place_of_performance_city_name],
          source_url: payload[:generated_internal_id],
          solicitation_number: payload[:piid],
          category: payload[:category],
          due_date: payload[:action_date],
          posted_at: payload[:action_date],
          contract_type: payload[:award_type],
          set_aside: payload[:set_aside_type],
          estimated_value_low: payload[:total_obligation],
          estimated_value_high: payload[:total_obligation],
          naics_codes: Array(payload[:naics_code]).compact,
          status: payload[:status] || "closed",
          raw_text: [payload[:award_description], payload[:awarding_agency_name]].compact.join(" ")
        }
      end

      private

      attr_reader :source
    end
  end
end
