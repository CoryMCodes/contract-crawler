class Attachment < ApplicationRecord
  belongs_to :opportunity

  validates :title, :file_url, presence: true
end
