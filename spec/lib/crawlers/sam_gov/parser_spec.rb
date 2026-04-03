require "rails_helper"

RSpec.describe Crawlers::SamGov::Parser do
  describe "#parse" do
    it "maps the SAM.gov response shape into source-specific attributes" do
      source = create(:source, kind: "sam_gov")
      payload = {
        noticeId: "ff826a59eac743c4a1a07ff5e0cf3e3a",
        title: "Test-Award notice-V2 27",
        solicitationNumber: "test-123456789",
        fullParentPathName: "GENERAL SERVICES ADMINISTRATION.FEDERAL ACQUISITION SERVICE",
        postedDate: "2020-07-02",
        type: "Award Notice",
        baseType: "Award Notice",
        archiveType: "autocustom",
        archiveDate: "2020-08-01",
        typeOfSetAsideDescription: "Total Small Business Set-Aside",
        responseDeadLine: "2020-08-15T17:00:00.000+00:00",
        naicsCode: "541512",
        classificationCode: "D302",
        active: "Yes",
        award: {
          number: "AWD-55",
          amount: 155000,
          date: "2020-07-03T00:00:00.000+00:00",
          awardee: {
            name: "Acme Services"
          }
        },
        officeAddress: {
          city: "CHICAGO",
          state: "IL",
          zipcode: "60604"
        },
        placeOfPerformance: {
          city: { name: "Milwaukee" },
          state: { code: "WI" },
          zip: "53202"
        },
        uiLink: "https://sam.gov/opp/ff826a59eac743c4a1a07ff5e0cf3e3a/view",
        resourceLinks: [
          "https://sam.gov/api/prod/opps/v3/opportunities/resources/files/1/download?api_key=abc"
        ]
      }

      attributes = described_class.new(source:).parse(payload)

      expect(attributes).to include(
        external_id: "ff826a59eac743c4a1a07ff5e0cf3e3a",
        title: "Test-Award notice-V2 27",
        buyer_name: "GENERAL SERVICES ADMINISTRATION.FEDERAL ACQUISITION SERVICE",
        state: "WI",
        city: "Milwaukee",
        source_url: "https://sam.gov/opp/ff826a59eac743c4a1a07ff5e0cf3e3a/view",
        solicitation_number: "test-123456789",
        category: "D302",
        contract_type: "Award Notice",
        set_aside: "Total Small Business Set-Aside",
        status: "Yes"
      )
      expect(attributes[:naics_codes]).to eq(["541512"])
      expect(attributes[:attachments]).to eq([
        {
          title: "Attachment 1",
          file_url: "https://sam.gov/api/prod/opps/v3/opportunities/resources/files/1/download?api_key=abc",
          content_type: nil,
          metadata: { source: "sam_gov", index: 1 }
        }
      ])
      expect(attributes[:award]).to include(
        vendor_name: "Acme Services",
        amount: 155000,
        award_number: "AWD-55"
      )
    end
  end
end
