module Ai
  class ExtractOpportunityFields
    def initialize(opportunity:)
      @opportunity = opportunity
    end

    def call
      {
        due_date: opportunity.due_date,
        contract_type: opportunity.contract_type,
        set_aside: opportunity.set_aside,
        naics_codes: opportunity.naics_codes
      }
    end

    private

    attr_reader :opportunity
  end
end
