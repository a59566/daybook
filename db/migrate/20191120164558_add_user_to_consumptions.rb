class AddUserToConsumptions < ActiveRecord::Migration[6.0]
  def change
    add_reference :consumptions, :user, index: true
  end
end
