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

    @cart_items.each do |cart_item|
      OrderItem.create(user_id: current_user.id, product_id: cart_item.product.id,
                            order_id: @order.id, price: cart_item.product.price, quantity: cart_item.quantity_in_cart)
      cart_item.destroy
      cart_item.product.stock_quantity -= cart_item.quantity_in_cart
      cart_item.product.save
    end
    @order_items = OrderItem.where(order_id: @order.id)
  end

end
