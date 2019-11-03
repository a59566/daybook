class Consumption < ApplicationRecord
  belongs_to :tag
  validates :detail, presence: true
  validates :amount, presence: true, numericality: true
  validates :date, presence: true
  validates :tag_id, presence: true
end
