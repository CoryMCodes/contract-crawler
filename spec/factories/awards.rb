FactoryBot.define do
  factory :award do
    association :opportunity
    vendor_name { "Acme Infrastructure" }
    amount { 250_000 }
    awarded_at { Date.current }
    award_number { "AWD-123" }
    source_url { "https://example.gov/awards/123" }
  end
end
