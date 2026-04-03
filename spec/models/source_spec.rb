require "rails_helper"

RSpec.describe Source, type: :model do
  subject(:source) { build(:source) }

  it { is_expected.to have_many(:source_records).dependent(:destroy) }
  it { is_expected.to have_many(:opportunities).dependent(:nullify) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }

  it "normalizes the slug for routing and lookup" do
    source.slug = "SAM Gov"

    source.validate

    expect(source.slug).to eq("sam-gov")
  end
end
