class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, default: "no name", limit: 50, null: false
      t.string :email, default: "no email", limit: 255, null: false
      t.string :password_digest, null: false
      t.string :remember_digest

      t.timestamps null: false
      t.index  :email, unique: true
      t.index  :remember_digest, unique: true
    end
  end
end
