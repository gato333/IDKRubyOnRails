class ChangeUsers < ActiveRecord::Migration
  def change
  	 add_index :user_events, [:user_id, :event_id]
  	 add_index :event_results, [:creator_id, :created_at]
  end
end
