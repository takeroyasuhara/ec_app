class Product < ActiveRecord::Base
  has_many :cart_items, dependent: :destroy
  has_many :purchasing_users, class_name: "User",through: :cart_items
  has_many :order_items
  has_many :purchased_users, class_name: "User",through: :order_items

  validates :title, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :image_url, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true
end
