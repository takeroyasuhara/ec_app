class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.belongs_to :user, default: 0, null: false
      t.belongs_to :product, default: 0, null: false
      t.integer :price_in_cart, default: 0, null: false
      t.integer :quantity_in_cart, default: 0, null: false
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
      t.index [:user_id, :product_id], unique: true
    end
  end
end
