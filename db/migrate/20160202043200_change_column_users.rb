class ChangeColumnUsers < ActiveRecord::Migration
  def change
  	change_table  :event_results do |t|
  		t.rename :user_id, :creator_id
  	end 
  end
end
