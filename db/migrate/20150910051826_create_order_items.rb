class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.belongs_to :user
      t.belongs_to :product
      t.belongs_to :order
      t.integer :price, null: false
      t.integer :quantity, null: false

      t.timestamps null: false
    end
  end
end
