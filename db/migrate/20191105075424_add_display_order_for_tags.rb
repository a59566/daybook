class AddDisplayOrderForTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :display_order, :integer
    add_index :tags, :display_order, unique: true
  end
end
