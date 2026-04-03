require "rails_helper"

RSpec.describe Normalization::OpportunityNormalizer do
  describe "#call" do
    it "maps a SAM.gov payload into the shared opportunity schema" do
      source = create(:source, name: "SAM.gov", slug: "sam-gov", kind: "sam_gov")
      parsed_attributes = {
        external_id: "SAM-001",
        title: "Bridge Repair Services",
        description: "Repair and resurface bridge decks.",
        buyer_name: "Texas Department of Transportation",
        state: "TX",
        city: "Austin",
        source_url: "https://sam.gov/opp/SAM-001",
        solicitation_number: "DOT-001",
        category: "construction",
        due_date: Time.zone.parse("2026-05-01 17:00:00 UTC"),
        posted_at: Time.zone.parse("2026-04-01 12:00:00 UTC"),
        contract_type: "Solicitation",
        set_aside: "Total Small Business",
        estimated_value_low: 125_000,
        estimated_value_high: 275_000,
        naics_codes: ["237310"],
        status: "Published",
        raw_text: "Bridge Repair Services Repair and resurface bridge decks."
      }

      normalized = described_class.new(source:, attributes: parsed_attributes).call

      expect(normalized).to include(
        external_id: "SAM-001",
        title: "Bridge Repair Services",
        buyer_name: "Texas Department of Transportation",
        state: "TX",
        city: "Austin",
        source_name: "SAM.gov",
        source_url: "https://sam.gov/opp/SAM-001",
        contract_type: "solicitation",
        set_aside: "small_business",
        status: "open"
      )
      expect(normalized[:naics_codes]).to eq(["237310"])
      expect(normalized[:estimated_value_low]).to eq(125_000)
      expect(normalized[:estimated_value_high]).to eq(275_000)
    end

    it "maps active yes/no statuses from SAM.gov into open and closed" do
      source = create(:source, name: "SAM.gov", slug: "sam-gov", kind: "sam_gov")

      active_notice = described_class.new(
        source:,
        attributes: { external_id: "A", title: "Active notice", status: "Yes" }
      ).call

      archived_notice = described_class.new(
        source:,
        attributes: { external_id: "B", title: "Archived notice", status: "No" }
      ).call

      expect(active_notice[:status]).to eq("open")
      expect(archived_notice[:status]).to eq("closed")
    end
  end
end
