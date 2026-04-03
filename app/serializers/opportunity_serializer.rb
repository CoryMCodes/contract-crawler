class OpportunitySerializer
  INDEX_FIELDS = %i[
    id
    external_id
    title
    buyer_name
    source_name
    state
    city
    due_date
    posted_at
    status
    summary_ai
  ].freeze

  DETAIL_FIELDS = (INDEX_FIELDS + %i[
    description
    source_url
    solicitation_number
    category
    contract_type
    set_aside
    estimated_value_low
    estimated_value_high
    naics_codes
    raw_text
  ]).freeze

  class << self
    def render_collection(opportunities)
      opportunities.map { |opportunity| render_index(opportunity) }
    end

    def render_index(opportunity)
      opportunity.slice(*INDEX_FIELDS.map(&:to_s))
    end

    def render_detail(opportunity)
      opportunity.slice(*DETAIL_FIELDS.map(&:to_s))
    end
  end
end
