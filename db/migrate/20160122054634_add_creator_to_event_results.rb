class AddCreatorToEventResults < ActiveRecord::Migration
  def change
    add_column :event_results, :creator, :string
  end
end
