class ChangeReachableDefaultForUsers < ActiveRecord::Migration
  def change
  	change_column :users, :reachable, :boolean, default: true
  end
end
