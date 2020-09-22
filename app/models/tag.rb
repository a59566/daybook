class Tag < ApplicationRecord
  has_many :consumptions, dependent: :restrict_with_error
  belongs_to :user

  include RankedModel
  ranks :display_order, with_same: :user_id

  validates :name, presence: true

  def self.csv_attributes
    ['name', 'created_at', 'updated_at', 'display_order']
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |tag|
        csv << csv_attributes.map { |attr| tag.send(attr) }
      end
    end
  end
end
