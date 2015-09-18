class OrdersController < ApplicationController

  def new
    @cart_items = current_user.cart_items
    @products = Product.joins(:cart_items).merge(@cart_items)
    @order = Order.new
    @addresses = Address.where(user_id: current_user.id)

    @products.each do |product|
      cart_item = @cart_items.find_by(product_id: product.id)
      if cart_item.asking_price != product.price
        flash.now[:warning] = "#{product.title}の価格が変わりました！"
        cart_item.asking_price = product.price
        cart_item.save
      elsif cart_item.asking_quantity > product.stock_quantity
        flash.now[:warning] = "#{product.title}の在庫数が足りなくなりました！"
      end
    end
  end


  def create
    @order = Order.create(address_text: params[:order][:address_text])
    @cart_items = current_user.cart_items
    ActiveRecord::Base.transaction do
      @products = Product.joins(:cart_items).merge(@cart_items).lock
      @products.each do |product|
      cart_item = @cart_items.find_by(product_id: product.id)
        if cart_item.asking_price != product.price
          flash.now[:warning] = "#{product.title}の価格が変わりました！カートを再確認ください"
          cart_item.asking_price = product.price
          cart_item.save
          break
        elsif cart_item.asking_quantity > product.stock_quantity
          flash.now[:warning] = "#{product.title}の在庫数が足りなくなりました！カートを再確認ください"
          break
        else
          OrderItem.create(user_id: current_user.id, product_id: product.id,
                            order_id: @order.id,price: product.price, quantity: cart_item.asking_quantity)
          cart_item.destroy
          product.stock_quantity -= cart_item.asking_quantity
          product.save
        end
      end
    end
    @order_items = OrderItem.where(order_id: @order.id)
  end

end
