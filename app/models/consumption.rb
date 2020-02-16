class Consumption < ApplicationRecord
  belongs_to :tag
  belongs_to :user

  scope :this_month, -> { where(date: Date.today.at_beginning_of_month..Date.today.at_end_of_month) }
  scope :recent, ->(day) { where(date: Date.today - day..Date.today - 1) }

  validates :detail, presence: true
  validates :amount, presence: true, numericality: true
  validates :date, presence: true
  validates :tag_id, presence: true
  validate do |consumption|
    # check if tag_id is belongs to user
    unless consumption.user.tags.find_by_id(consumption.tag_id)
      errors.add(:tag_id, :invalid)
    end
  end
end
