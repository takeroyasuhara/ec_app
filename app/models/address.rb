class Address < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validates :address, presence: true, length: { maximum: 500 }
  validates :user_id, presence: true
end
