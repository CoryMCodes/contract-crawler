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
          description: normalize_description(payload[:description]),
          buyer_name: payload[:fullParentPathName] || payload[:department] || payload.dig(:organization, :name),
          state: payload.dig(:placeOfPerformance, :state, :code) || payload.dig(:officeAddress, :state),
          city: payload.dig(:placeOfPerformance, :city, :name) || payload.dig(:officeAddress, :city),
          source_url: payload[:uiLink],
          solicitation_number: payload[:solicitationNumber],
          category: payload[:classificationCode],
          due_date: payload[:responseDeadLine],
          posted_at: payload[:postedDate],
          contract_type: payload[:type] || payload[:baseType],
          set_aside: payload[:typeOfSetAsideDescription] || payload[:setAside],
          naics_codes: Array(payload[:naicsCode] || payload[:naics_codes]).compact,
          status: payload[:status] || payload[:active],
          raw_text: [
            payload[:title],
            normalize_description(payload[:description]),
            payload[:fullParentPathName],
            payload[:solicitationNumber]
          ].compact.join(" "),
          attachments: parse_attachments(payload[:resourceLinks]),
          award: parse_award(payload[:award])
        }
      end

      private

      attr_reader :source

      def normalize_description(value)
        return if value.blank?
        return if value.to_s.match?(%r{\Ahttps?://}i)

        value
      end

      def parse_attachments(resource_links)
        Array(resource_links).compact.each_with_index.map do |file_url, index|
          {
            title: "Attachment #{index + 1}",
            file_url:,
            content_type: nil,
            metadata: { source: "sam_gov", index: index + 1 }
          }
        end
      end

      def parse_award(award_payload)
        return if award_payload.blank?

        award = award_payload.deep_symbolize_keys
        {
          vendor_name: award.dig(:awardee, :name) || award[:awardeeName],
          amount: award[:amount],
          awarded_at: award[:date],
          award_number: award[:number],
          source_url: nil
        }.compact
      end
    end
  end
end
