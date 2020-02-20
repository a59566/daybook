class Tag < ApplicationRecord
  has_many :consumptions
  belongs_to :user

  include RankedModel
  ranks :display_order, with_same: :user_id

  validates :name, presence: true
end
