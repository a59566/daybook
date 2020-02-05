class Consumption < ApplicationRecord
  belongs_to :tag
  belongs_to :user

  scope :this_month, -> { where(date: Date.today.at_beginning_of_month..Date.today.at_end_of_month) }
  scope :recent, ->(day) { where(date: Date.today - day..Date.today - 1) }

  validates :detail, presence: true
  validates :amount, presence: true, numericality: true
  validates :date, presence: true
  validates :tag_id, presence: true
end
