require "rails_helper"

RSpec.describe "Opportunities API", type: :request do
  describe "GET /opportunities" do
    it "supports full-text search and core filters" do
      source = create(:source, name: "SAM.gov", slug: "sam-gov")
      tx_opportunity = create(
        :opportunity,
        source:,
        title: "Bridge Repair Services",
        description: "Bridge resurfacing work across Austin.",
        raw_text: "Bridge Repair Services Austin resurfacing",
        state: "TX",
        status: "open",
        due_date: Date.new(2026, 5, 1)
      )
      create(
        :opportunity,
        title: "School Cafeteria Supplies",
        raw_text: "School Cafeteria Supplies California food services",
        state: "CA",
        status: "closed",
        due_date: Date.new(2026, 4, 10)
      )

      get "/opportunities", params: {
        q: "bridge",
        state: "TX",
        status: "open",
        due_before: "2026-05-15",
        source: source.slug
      }

      expect(response).to have_http_status(:ok)
      expect(json_body.fetch("data").map { |row| row.fetch("id") }).to eq([tx_opportunity.id])
    end
  end

  describe "GET /opportunities/:id" do
    it "returns normalized fields with related awards and attachments" do
      opportunity = create(:opportunity)
      create(:award, opportunity:, vendor_name: "Acme Infrastructure")
      create(:attachment, opportunity:, title: "Solicitation PDF")

      get "/opportunities/#{opportunity.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body.fetch("data")).to include(
        "id" => opportunity.id,
        "title" => opportunity.title,
        "summary_ai" => opportunity.summary_ai
      )
      expect(json_body.fetch("included").fetch("awards").first.fetch("vendor_name")).to eq("Acme Infrastructure")
      expect(json_body.fetch("included").fetch("attachments").first.fetch("title")).to eq("Solicitation PDF")
    end
  end
end
