class AddCreatorIdToEventResults < ActiveRecord::Migration
  def change
    add_column :event_results, :creator_id, :integer
  end
end
