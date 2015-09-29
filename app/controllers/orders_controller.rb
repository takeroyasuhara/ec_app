class OrdersController < ApplicationController
  before_action :signed_in_user

  def new
    @cart_items = current_user.cart_items
    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)

    if params[:token] != @long_token
      flash.now[:warning] = "カート内の情報に変更がありました。注文内容を再確認して注文を確定してください！"
    end

    @cart_items.includes(:product).each do |cart_item|
      if cart_item.price_in_cart != cart_item.product.price
        flash.now[:warning] = "カート内の商品価格に変更がありました。注文内容を再確認して注文を確定してください！"
      end
    end

    @order = Order.new
    @addresses = Address.where(user_id: current_user.id)

  end


  def create
    ActiveRecord::Base.transaction do
      @cart_items = current_user.cart_items.lock
      connect_token = ""
      @cart_items.includes(:product).each do |cart_item|
        connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
      end
      @long_token = CartItem.encrypt(connect_token)
      if params[:token] != @long_token
        return redirect_to confirmation_path
      end
      @order = Order.create(address_text: params[:order][:address_text])
      order_items = []
      @cart_items.order('product_id').each do |cart_item|
        product = Product.lock.find(cart_item.product_id)
        order_item = OrderItem.new(user_id: current_user.id, product_id: product.id,
                              order_id: @order.id, price: cart_item.price_in_cart, quantity: cart_item.quantity_in_cart)
        order_items << order_item
        product.update_attribute(:stock_quantity, product.stock_quantity - cart_item.quantity_in_cart)
      end
      OrderItem.import order_items
      CartItem.where(user_id: current_user.id).delete_all
    end
  end

end
