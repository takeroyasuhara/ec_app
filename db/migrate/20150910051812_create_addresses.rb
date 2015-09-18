class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address_text, limit: 250, null: false
      t.belongs_to :user, default: 0, null: false

      t.timestamps null: false
      t.index :user_id
    end
  end
end
