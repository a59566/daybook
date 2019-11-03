class AddConstraintsForConsumptions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :consumptions, :detail, false
    change_column_null :consumptions, :amount, false
    change_column_null :consumptions, :date, false
    change_column_null :consumptions, :tag_id, false
  end
end
