class AddIndexForConsumptionsDate < ActiveRecord::Migration[6.0]
  def change
    add_index :consumptions, :date
  end
end
