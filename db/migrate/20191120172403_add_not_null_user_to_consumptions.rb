class AddNotNullUserToConsumptions < ActiveRecord::Migration[6.0]
  def up
    change_column_null :consumptions, :user_id, false
  end

  def down
    change_column_null :consumptions, :user_id, true
  end
end
