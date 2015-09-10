class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|      
      t.string :title, limit: 20, null: false
      t.text :description, limit: 500, null: false
      t.string :image_url, null: false
      t.integer :price, null: false
      t.integer :stock_quantity, null: false

      t.timestamps null: false
    end
  end
end
