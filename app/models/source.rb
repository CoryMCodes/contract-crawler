class Source < ApplicationRecord
  has_many :source_records, dependent: :destroy
  has_many :opportunities, dependent: :nullify

  validates :name, :slug, :kind, presence: true
  validates :slug, uniqueness: { case_sensitive: false }

  before_validation :normalize_slug

  private

  def normalize_slug
    self.slug = slug.to_s.parameterize if slug.present?
  end
end
