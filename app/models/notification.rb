class Notification < ActiveRecord::Base
  belongs_to :cart_item

  validates :cart_item_id, presence: true
  validates :asking_price, presence: true
  validates :asking_quantity, presence: true
  validates :stock_quantity, presence: true
end
