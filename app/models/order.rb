class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :address

  validates :address_id, presence: true
end
