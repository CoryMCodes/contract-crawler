class Award < ApplicationRecord
  belongs_to :opportunity

  validates :vendor_name, presence: true
end
