class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.belongs_to :user, default: 0, null: false
      t.belongs_to :product, default: 0, null: false
      t.belongs_to :order, default: 0, null: false
      t.integer :price, default: 0, null: false
      t.integer :quantity, default: 0, null: false

      t.timestamps null: false
    end
  end
end
