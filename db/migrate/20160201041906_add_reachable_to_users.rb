class AddReachableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reachable, :boolean, default: false
  end
end
