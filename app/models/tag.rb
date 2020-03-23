class Tag < ApplicationRecord
  has_many :consumptions, dependent: :restrict_with_error
  belongs_to :user

  include RankedModel
  ranks :display_order, with_same: :user_id

  validates :name, presence: true
end
