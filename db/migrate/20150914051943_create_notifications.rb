class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :cart_item_id, null: false
      t.integer :asking_price, null: false
      t.integer :price, null: false
      t.integer :asking_quantity, null: false
      t.integer :stock_quantity, null: false

      t.timestamps null: false
    end
  end
end
