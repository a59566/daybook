class AddNotNullUserToConsumptions < ActiveRecord::Migration[6.0]
  def up
    execute 'UPDATE consumptions SET user_id = 1'
    change_column_null :consumptions, :user_id, false
  end

  def down
    change_column_null :consumptions, :user_id, true
  end
end
