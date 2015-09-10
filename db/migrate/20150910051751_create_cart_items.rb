class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.belongs_to :user, null: false
      t.belongs_to :product, null: false
      t.integer :asking_price, null: false
      t.integer :asking_quantity, null: false

      t.timestamps null: false
    end
  end
end
