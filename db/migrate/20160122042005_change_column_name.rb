class ChangeColumnName < ActiveRecord::Migration
  def change
  	change_table :users do |t|
      t.rename :userType, :user_type
    end
  end
end
