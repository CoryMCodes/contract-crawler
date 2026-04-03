FactoryBot.define do
  factory :attachment do
    association :opportunity
    title { "Bid Package" }
    file_url { "https://example.gov/files/bid-package.pdf" }
    content_type { "application/pdf" }
    metadata { {} }
  end
end
