class ChangeCreatorColumnName < ActiveRecord::Migration
  def change
  	change_table :event_results do |t|
      t.rename :creator, :creator_name
    end
  end
end
