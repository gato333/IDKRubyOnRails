class CreateEventResults < ActiveRecord::Migration
  def change
    create_table :event_results do |t|
      t.string :name
      t.string :location
      t.string :image
      t.float :lat
      t.float :long
      t.string :time
      t.string :date
      t.string :type

      t.timestamps null: false
    end
  end
end
