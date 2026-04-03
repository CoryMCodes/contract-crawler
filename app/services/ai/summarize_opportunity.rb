module Ai
  class SummarizeOpportunity
    def initialize(opportunity:)
      @opportunity = opportunity
    end

    def call
      return opportunity.summary_ai if opportunity.summary_ai.present?

      [opportunity.title, opportunity.description].compact.join(": ").truncate(280)
    end

    private

    attr_reader :opportunity
  end
end
