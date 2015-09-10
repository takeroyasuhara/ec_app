class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.belongs_to :user, null: false
      t.belongs_to :product, null: false
      t.belongs_to :order, null: false
      t.integer :price, null: false
      t.integer :quantity, null: false

      t.timestamps null: false
    end
  end
end
