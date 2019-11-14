class AddConstraintsForTagsDisplayOrder < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tags, :display_order, false
  end
end
