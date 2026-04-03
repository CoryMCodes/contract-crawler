class Opportunity < ApplicationRecord
  belongs_to :source
  belongs_to :source_record
  belongs_to :buyer

  has_many :attachments, dependent: :destroy
  has_many :awards, dependent: :destroy

  validates :external_id, :title, :status, presence: true
  validates :external_id, uniqueness: { scope: :source_id }
end
