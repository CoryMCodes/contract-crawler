class Buyer < ApplicationRecord
  has_many :opportunities, dependent: :nullify

  validates :name, presence: true
end
