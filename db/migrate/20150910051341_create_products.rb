class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, default: "no title", limit: 20, null: false
      t.text :description, default: "no text", limit: 500, null: false
      t.string :image_url, default: "no url", null: false
      t.integer :price, default: 0, null: false
      t.integer :stock_quantity, default: 0, null: false

      t.timestamps null: false
    end
  end
end
