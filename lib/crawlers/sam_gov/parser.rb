module Crawlers
  module SamGov
    class Parser
      def initialize(source:)
        @source = source
      end

      def parse(raw_payload)
        payload = raw_payload.deep_symbolize_keys
        {
          external_id: payload[:noticeId] || payload[:external_id],
          title: payload[:title],
          description: payload[:description],
          buyer_name: payload[:department] || payload.dig(:organization, :name),
          state: payload.dig(:placeOfPerformance, :state, :code) || payload.dig(:officeAddress, :state),
          city: payload.dig(:placeOfPerformance, :city, :name) || payload.dig(:officeAddress, :city),
          source_url: payload[:uiLink],
          solicitation_number: payload[:solicitationNumber],
          category: payload[:classificationCode],
          due_date: payload[:responseDeadLine],
          posted_at: payload[:postedDate],
          contract_type: payload[:type],
          set_aside: payload[:setAside],
          naics_codes: Array(payload[:naicsCode] || payload[:naics_codes]).compact,
          status: payload[:status] || payload[:active],
          raw_text: [payload[:title], payload[:description]].compact.join(" ")
        }
      end

      private

      attr_reader :source
    end
  end
end
