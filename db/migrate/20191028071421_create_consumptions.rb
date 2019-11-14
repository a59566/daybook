class CreateConsumptions < ActiveRecord::Migration[6.0]
  def change
    create_table :consumptions do |t|
      t.string :detail
      t.integer :amount
      t.date :date

      t.timestamps
    end
  end
end
