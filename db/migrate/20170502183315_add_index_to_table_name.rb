class AddIndexToTableName < ActiveRecord::Migration
  def change
    add_index :event_results, [:name, :startdate], unique: true
  end
end
