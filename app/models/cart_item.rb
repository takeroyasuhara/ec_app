class CartItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :price_in_cart, presence: true
  validates :quantity_in_cart, presence: true,
              numericality: { only_integer: true, greater_than: 0 }
end
