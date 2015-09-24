class CartItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :price_in_cart, presence: true
  validates :quantity_in_cart, presence: true,
              numericality: { only_integer: true, greater_than: 0 }


  def CartItem.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # 乱数生成
  def CartItem.new_token
    SecureRandom.urlsafe_base64
  end


  def create_lock_token
    lock_token = CartItem.encrypt(CartItem.new_token)
    update_attribute(:lock_token, lock_token)
  end

  def forget
    update_attribute(:lock_token, nil)
  end

end
