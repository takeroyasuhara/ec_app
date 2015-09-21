class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :address_text, default: "no text", limit: 250, null: false

      t.timestamps null: false
    end
  end
end
