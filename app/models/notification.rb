class Notification < ActiveRecord::Base
  belongs_to :cart_item
end
