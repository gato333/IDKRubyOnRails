class ChangeColumnEventResults < ActiveRecord::Migration
  def change
  	change_table :event_results do |t|
      t.rename :creator_id, :user_id
    end
  end
end
