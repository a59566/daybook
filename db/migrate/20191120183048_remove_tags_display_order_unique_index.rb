class RemoveTagsDisplayOrderUniqueIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :tags, :display_order
    add_index :tags, :display_order
  end
end
