class SourceRecord < ApplicationRecord
  STATUSES = %w[fetched parsed normalized enriched failed].freeze

  belongs_to :source
  has_many :opportunities, dependent: :nullify

  validates :external_id, :fingerprint, :raw_payload, presence: true
  validates :fingerprint, uniqueness: { scope: :source_id }
  validates :status, inclusion: { in: STATUSES }
end
