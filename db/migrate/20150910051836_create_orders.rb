class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :address_text, null: false

      t.timestamps null: false
    end
  end
end
