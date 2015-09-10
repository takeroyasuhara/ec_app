class CartItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :asking_price, presence: true
  validates :asking_quantity, presence: true
end
