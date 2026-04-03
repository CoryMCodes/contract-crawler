FactoryBot.define do
  factory :buyer do
    sequence(:name) { |n| "Buyer #{n}" }
    state { "TX" }
    city { "Austin" }
    source_identifier { SecureRandom.hex(4) }
  end
end
