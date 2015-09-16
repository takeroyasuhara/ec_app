class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, limit: 50, null: false
      t.string :email, limit: 256, null: false
      t.string :password_digest, null: false

      t.timestamps null: false
      t.index  :email, unique: true
    end
  end
end
