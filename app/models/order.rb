class Order < ActiveRecord::Base
  has_many :order_items

  validates :address_text, presence: true
end
