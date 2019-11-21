class AddNotNullUserToTags < ActiveRecord::Migration[6.0]
  def up
    execute 'UPDATE tags SET user_id = 1'
    change_column_null :tags, :user_id, false
  end

  def down
    change_column_null :tags, :user_id, true
  end
end
