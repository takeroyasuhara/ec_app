class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_text, limit: 250, null: false
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
