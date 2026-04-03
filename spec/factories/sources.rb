FactoryBot.define do
  factory :source do
    sequence(:name) { |n| "Source #{n}" }
    sequence(:slug) { |n| "source-#{n}" }
    kind { "sam_gov" }
    base_url { "https://example.gov" }
    active { true }
    settings { {} }
  end
end
