class Tag < ApplicationRecord
  has_many :consumptions
  belongs_to :user

  validates :name, presence: true
end
