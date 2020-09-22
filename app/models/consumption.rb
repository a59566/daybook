class Consumption < ApplicationRecord
  belongs_to :tag
  belongs_to :user

  scope :this_month, -> { where(date: Date.today.at_beginning_of_month..Date.today.at_end_of_month) }

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

  def self.csv_attributes
    ['detail', 'amount', 'date', 'created_at', 'updated_at', 'tag_name']
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.includes(:tag).each do |consumption|
        csv << csv_attributes.map do |attr|
          attr == 'tag_name' ? consumption.tag.name : consumption.send(attr)
        end
      end
    end
  end
end
