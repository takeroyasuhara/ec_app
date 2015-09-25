class OrdersController < ApplicationController

  def new
    @cart_items = current_user.cart_items
    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)

    if params[:token] != @long_token
      flash[:danger] = "カート内の情報に変更があります。再度カート内の商品をご確認ください！"
      return redirect_to cart_items_path
    end

    @order = Order.new
    @addresses = Address.where(user_id: current_user.id)

  end


  def create
    @order = Order.create(address_text: params[:order][:address_text])
    @cart_items = current_user.cart_items

    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)

    if params[:token] != @long_token
      flash[:danger] = "カート内の情報に変更があります。再度カート内の商品をご確認ください！"
      return redirect_to cart_items_path
    end

    ActiveRecord::Base.transaction do
      @cart_items.each do |cart_item|
        product = Product.lock.find(cart_item.product_id)
        OrderItem.create(user_id: current_user.id, product_id: product.id,
                              order_id: @order.id, price: product.price, quantity: cart_item.quantity_in_cart)
        cart_item.destroy!
        product.stock_quantity -= cart_item.quantity_in_cart
        product.save!
      end
    end
    @order_items = OrderItem.where(order_id: @order.id)
  end

end
