class AddTagForConsumption < ActiveRecord::Migration[6.0]
  def up
    add_reference :consumptions, :tag, index: true
  end

  def down
    remove_reference :consumptions, :tag, index: true
  end
end
