# frozen_string_literal: true

sam_source = Source.find_or_create_by!(slug: "sam-gov") do |source|
  source.name = "SAM.gov"
  source.kind = "sam_gov"
  source.base_url = "https://sam.gov"
  source.active = true
  source.settings = {
    posted_days_back: 30
  }
end

usaspending_source = Source.find_or_create_by!(slug: "usaspending") do |source|
  source.name = "USAspending"
  source.kind = "usaspending"
  source.base_url = "https://www.usaspending.gov"
  source.active = true
end

buyer = Buyer.find_or_create_by!(name: "Texas Department of Transportation") do |record|
  record.city = "Austin"
  record.state = "TX"
  record.source_identifier = "txdot"
  record.website_url = "https://www.txdot.gov"
end

sam_source_record = SourceRecord.find_or_create_by!(
  source: sam_source,
  fingerprint: "seed:sam-gov:bridge-repair-services"
) do |record|
  record.external_id = "SAM-SEED-001"
  record.raw_payload = {
    noticeId: "SAM-SEED-001",
    title: "Bridge Repair Services",
    description: "Repair and resurface bridge decks across Central Texas corridors."
  }
  record.raw_body = record.raw_payload.to_json
  record.fetched_at = Time.zone.parse("2026-04-03 09:00:00 UTC")
  record.parser_version = "seed-v1"
  record.status = "normalized"
end

bridge_opportunity = Opportunity.find_or_initialize_by(
  source: sam_source,
  external_id: "SAM-SEED-001"
)
bridge_opportunity.assign_attributes(
  source_record: sam_source_record,
  buyer: buyer,
  title: "Bridge Repair Services",
  description: "Repair and resurface bridge decks across Central Texas corridors.",
  buyer_name: buyer.name,
  state: "TX",
  city: "Austin",
  source_name: sam_source.name,
  source_url: "https://sam.gov/opp/SAM-SEED-001",
  solicitation_number: "TXDOT-2026-001",
  category: "construction",
  due_date: Time.zone.parse("2026-05-15 17:00:00 UTC"),
  posted_at: Time.zone.parse("2026-04-01 14:00:00 UTC"),
  contract_type: "solicitation",
  set_aside: "small_business",
  estimated_value_low: 125_000,
  estimated_value_high: 275_000,
  naics_codes: ["237310"],
  status: "open",
  raw_text: "Bridge Repair Services Repair and resurface bridge decks across Central Texas corridors.",
  summary_ai: "District-wide bridge repair package for Central Texas with a mid-May due date and small business set-aside.",
  metadata: {
    seeded: true,
    priority: "high"
  }
)
bridge_opportunity.save!

Attachment.find_or_create_by!(
  opportunity: bridge_opportunity,
  file_url: "https://example.gov/files/bridge-repair-package.pdf"
) do |record|
  record.title = "Solicitation Package"
  record.content_type = "application/pdf"
  record.metadata = { seeded: true }
end

Award.find_or_create_by!(
  opportunity: bridge_opportunity,
  award_number: "AWD-SEED-001"
) do |record|
  record.vendor_name = "Acme Infrastructure"
  record.amount = 248_500
  record.awarded_at = Date.new(2025, 11, 15)
  record.source_url = "https://www.usaspending.gov/award/AWD-SEED-001"
end

usaspending_source_record = SourceRecord.find_or_create_by!(
  source: usaspending_source,
  fingerprint: "seed:usaspending:rural-broadband-expansion"
) do |record|
  record.external_id = "USA-SEED-001"
  record.raw_payload = {
    award_id: "USA-SEED-001",
    title: "Rural Broadband Expansion Planning",
    description: "Planning support for statewide rural broadband grant deployment."
  }
  record.raw_body = record.raw_payload.to_json
  record.fetched_at = Time.zone.parse("2026-04-03 10:00:00 UTC")
  record.parser_version = "seed-v1"
  record.status = "normalized"
end

second_buyer = Buyer.find_or_create_by!(name: "California Department of Technology") do |record|
  record.city = "Sacramento"
  record.state = "CA"
  record.source_identifier = "ca-dt"
  record.website_url = "https://cdt.ca.gov"
end

Opportunity.find_or_initialize_by(
  source: usaspending_source,
  external_id: "USA-SEED-001"
).tap do |opportunity|
  opportunity.assign_attributes(
    source_record: usaspending_source_record,
    buyer: second_buyer,
    title: "Rural Broadband Expansion Planning",
    description: "Planning support for statewide rural broadband grant deployment.",
    buyer_name: second_buyer.name,
    state: "CA",
    city: "Sacramento",
    source_name: usaspending_source.name,
    source_url: "https://www.usaspending.gov/search/?hash=USA-SEED-001",
    solicitation_number: "CDT-PLAN-44",
    category: "professional_services",
    due_date: Time.zone.parse("2026-04-28 20:00:00 UTC"),
    posted_at: Time.zone.parse("2026-04-02 16:00:00 UTC"),
    contract_type: "planning_services",
    set_aside: "none",
    estimated_value_low: 80_000,
    estimated_value_high: 140_000,
    naics_codes: ["541690"],
    status: "open",
    raw_text: "Rural Broadband Expansion Planning statewide rural broadband grant deployment.",
    summary_ai: "Broadband planning engagement focused on statewide deployment readiness and grant coordination.",
    metadata: {
      seeded: true,
      priority: "medium"
    }
  )
  opportunity.save!
end

puts "Seeded #{Source.count} sources, #{Buyer.count} buyers, and #{Opportunity.count} opportunities."
