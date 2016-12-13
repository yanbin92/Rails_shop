class AddIsAccessToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_access, :bool
  end
end
