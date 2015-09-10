class OrderItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :order

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :order_id, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end
