FactoryBot.define do
  factory :opportunity do
    association :source
    association :source_record
    association :buyer
    sequence(:external_id) { |n| "OPP-#{n}" }
    sequence(:title) { |n| "Opportunity #{n}" }
    description { "Bridge repair opportunity" }
    buyer_name { buyer.name }
    source_name { source.name }
    state { "TX" }
    city { "Austin" }
    source_url { "https://example.gov/opportunity" }
    solicitation_number { "SOL-100" }
    category { "construction" }
    due_date { 2.weeks.from_now }
    posted_at { Time.zone.now }
    contract_type { "solicitation" }
    set_aside { "small_business" }
    estimated_value_low { 50_000 }
    estimated_value_high { 125_000 }
    naics_codes { %w[237310] }
    status { "open" }
    raw_text { "Bridge repair opportunity in Austin, TX" }
    summary_ai { "AI summary of the bridge repair opportunity." }
    metadata { {} }
  end
end
