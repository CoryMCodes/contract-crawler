require "rails_helper"

RSpec.describe SourceRecord, type: :model do
  subject(:source_record) { build(:source_record) }

  it { is_expected.to belong_to(:source) }
  it { is_expected.to have_many(:opportunities).dependent(:nullify) }
  it { is_expected.to validate_presence_of(:external_id) }
  it { is_expected.to validate_presence_of(:fingerprint) }
  it { is_expected.to validate_presence_of(:raw_payload) }

  it "prevents duplicate payload snapshots for the same source fingerprint" do
    create(:source_record, source: source_record.source, fingerprint: "same-fingerprint")
    duplicate = build(:source_record, source: source_record.source, fingerprint: "same-fingerprint")

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:fingerprint]).to include("has already been taken")
  end
end
