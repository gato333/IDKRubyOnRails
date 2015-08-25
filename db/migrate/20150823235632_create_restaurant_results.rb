class CreateRestaurantResults < ActiveRecord::Migration
  def change
    create_table :restaurant_results do |t|
      t.string :name
      t.string :location
      t.string :image
      t.float :lat
      t.float :long
      t.string :type

      t.timestamps null: false
    end

  end
end
