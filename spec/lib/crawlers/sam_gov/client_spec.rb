require "rails_helper"

RSpec.describe Crawlers::SamGov::Client do
  describe "#fetch" do
    it "raises a configuration error when no API key is available" do
      source = create(:source, kind: "sam_gov", settings: {})

      client = described_class.new(source:)

      expect { client.fetch }.to raise_error(Crawlers::SamGov::Client::ConfigurationError, /SAM_GOV_API_KEY/)
    end

    it "fetches all pages from the SAM.gov opportunities API" do
      source = create(
        :source,
        kind: "sam_gov",
        settings: {
          "api_key" => "test-api-key",
          "limit" => 2,
          "posted_days_back" => 30,
          "ptype" => "o,k"
        }
      )

      stub_request(:get, "https://api.sam.gov/opportunities/v2/search")
        .with(query: hash_including(
          "api_key" => "test-api-key",
          "limit" => "2",
          "offset" => "0",
          "postedFrom" => Date.current.advance(days: -30).strftime("%m/%d/%Y"),
          "postedTo" => Date.current.strftime("%m/%d/%Y"),
          "ptype" => "o,k"
        ))
        .to_return(
          status: 200,
          body: {
            totalRecords: 3,
            limit: 2,
            offset: 0,
            opportunitiesData: [
              { noticeId: "A-1", title: "Bridge Repair" },
              { noticeId: "A-2", title: "Road Striping" }
            ]
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      stub_request(:get, "https://api.sam.gov/opportunities/v2/search")
        .with(query: hash_including(
          "api_key" => "test-api-key",
          "limit" => "2",
          "offset" => "2",
          "ptype" => "o,k"
        ))
        .to_return(
          status: 200,
          body: {
            totalRecords: 3,
            limit: 2,
            offset: 2,
            opportunitiesData: [
              { noticeId: "A-3", title: "Broadband Planning" }
            ]
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      payloads = described_class.new(source:).fetch

      expect(payloads.map { |payload| payload.fetch("noticeId") }).to eq(%w[A-1 A-2 A-3])
    end
  end
end
