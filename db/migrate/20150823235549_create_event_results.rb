class CreateEventResults < ActiveRecord::Migration
  def change
    create_table :event_results do |t|
      t.string :name
      t.string :address
      t.string :imageurl
      t.string :eventurl
      t.float :lat
      t.float :long
      t.datetime :startdate
      t.datetime :enddate
      t.string :types
      t.string :description
      t.string :price
      t.string :source

      t.timestamps null: false
    end
  end

end
