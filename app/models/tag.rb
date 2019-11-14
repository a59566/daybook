class Tag < ApplicationRecord
  has_many :consumptions
  validates :name, presence: true
end
