class OrdersController < ApplicationController

  def new
    @cart_items = current_user.cart_items
    @products = Product.joins(:cart_items).merge(@cart_items)
    @order = Order.new
    @addresses = Address.where(user_id: current_user.id)
  end


  def create
    @order = Order.create(address_text: params[:order][:address_text])
    @cart_items = current_user.cart_items
    @products = Product.joins(:cart_items).merge(@cart_items)

    @products.each do |product|
      cart_item = @cart_items.find_by(product_id: product.id)
      OrderItem.create(user_id: current_user.id, product_id: product.id,
                        order_id: @order.id,price: product.price, quantity: cart_item.asking_quantity)
      cart_item.destroy
      product.stock_quantity -= cart_item.asking_quantity
      product.save
    end
    @order_items = OrderItem.where(order_id: @order.id)
  end

end
