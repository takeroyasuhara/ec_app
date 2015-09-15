class Address < ActiveRecord::Base
  belongs_to :user

  validates :address_text, presence: true, length: { maximum: 250 }
  validates :user_id, presence: true
end
