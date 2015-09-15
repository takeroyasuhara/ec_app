class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :cart_item_id
      t.integer :asking_price
      t.integer :price
      t.integer :asking_quantity
      t.integer :stock_quantity

      t.timestamps null: false
    end
  end
end
