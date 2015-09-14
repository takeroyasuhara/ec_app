class Address < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true, length: { maximum: 500 }
  validates :user_id, presence: true
end
