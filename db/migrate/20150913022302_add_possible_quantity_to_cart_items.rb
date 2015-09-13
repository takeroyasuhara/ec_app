class AddPossibleQuantityToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :possible_quantity, :integer
  end
end
