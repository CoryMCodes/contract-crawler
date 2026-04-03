require "rails_helper"

RSpec.describe SourceIngestion::SyncSource do
  describe "#call" do
    it "stores raw payloads before normalization and stays idempotent" do
      source = create(:source, name: "SAM.gov", slug: "sam-gov", kind: "sam_gov")
      crawler = instance_double(Crawlers::BaseCrawler)
      raw_payload = { "noticeId" => "SAM-001", "title" => "Bridge Repair Services" }
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
        raw_text: "Bridge Repair Services Repair and resurface bridge decks.",
        attachments: [
          {
            title: "Attachment 1",
            file_url: "https://sam.gov/attachments/bridge-repair.pdf",
            content_type: "application/pdf",
            metadata: { source: "sam_gov" }
          }
        ],
        award: {
          vendor_name: "Acme Infrastructure",
          amount: 275_000,
          awarded_at: Date.new(2026, 4, 15),
          award_number: "AWD-001",
          source_url: "https://sam.gov/awards/AWD-001"
        }
      }

      allow(Crawlers::Registry).to receive(:build).with(source).and_return(crawler)
      allow(crawler).to receive(:fetch).and_return([raw_payload])
      allow(crawler).to receive(:external_id).with(raw_payload).and_return("SAM-001")
      allow(crawler).to receive(:fingerprint).with(raw_payload).and_return("sha256:sam-001")
      allow(crawler).to receive(:parse).with(raw_payload).and_return(parsed_attributes)

      service = described_class.new(source:)

      expect { service.call }.to change(SourceRecord, :count).by(1).and change(Opportunity, :count).by(1)

      source_record = SourceRecord.last
      opportunity = Opportunity.last

      expect(source_record.raw_payload).to eq(raw_payload)
      expect(source_record.status).to eq("normalized")
      expect(opportunity.source_record).to eq(source_record)
      expect(opportunity.external_id).to eq("SAM-001")
      expect(opportunity.attachments.count).to eq(1)
      expect(opportunity.attachments.first.file_url).to eq("https://sam.gov/attachments/bridge-repair.pdf")
      expect(opportunity.awards.count).to eq(1)
      expect(opportunity.awards.first.vendor_name).to eq("Acme Infrastructure")

      expect { service.call }.not_to change(SourceRecord, :count)
      expect(Opportunity.count).to eq(1)
      expect(Attachment.count).to eq(1)
      expect(Award.count).to eq(1)
    end
  end
end
