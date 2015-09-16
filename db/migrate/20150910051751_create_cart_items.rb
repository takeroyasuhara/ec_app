class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.belongs_to :user
      t.belongs_to :product
      t.integer :asking_price, null: false
      t.integer :asking_quantity, null: false
      t.integer :possible_quantity, null:false

      t.timestamps null: false
      t.index [:user_id, :product_id], unique: true
    end
  end
end
