FactoryBot.define do
  factory :source_record do
    association :source
    sequence(:external_id) { |n| "EXT-#{n}" }
    sequence(:fingerprint) { |n| "fingerprint-#{n}" }
    raw_payload { { title: "Bridge repair" } }
    raw_body { "{\"title\":\"Bridge repair\"}" }
    fetched_at { Time.zone.now }
    parser_version { "v1" }
    status { "fetched" }
  end
end
