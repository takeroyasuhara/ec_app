class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_text, limit: 500, null: false
      t.belongs_to :user, null: false

      t.timestamps null: false
    end
  end
end
