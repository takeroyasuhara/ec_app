class OrdersController < ApplicationController

  def new
    @cart_items = current_user.cart_items
    @order = Order.new
    @addresses = Address.where(user_id: current_user.id)

    @cart_items.includes(:product).each do |cart_item|
      if cart_item.price_in_cart != cart_item.product.price
        flash.now[:warning] = "#{cart_item.product.title}の価格が
        #{cart_item.price_in_cart}円から#{cart_item.product.price}円に変わりました！"
        cart_item.price_in_cart = cart_item.product.price
        cart_item.save
      end
    end
  end


  def create
    @order = Order.create(address_text: params[:order][:address_text])
    @cart_items = current_user.cart_items

    @cart_items.each do |cart_item|
      if cart_item.price_in_cart != cart_item.product.price
        flash.now[:warning] = "#{cart_item.product.title}の価格が
        #{cart_item.price_in_cart}円から#{cart_item.product.price}円に変わりました！カートを再確認ください！"
        cart_item.price_in_cart = cart_item.product.price
        cart_item.save
        break
      elsif cart_item.quantity_in_cart > cart_item.product.stock_quantity
        flash.now[:warning] = "#{cart_item.product.title}の在庫数が足りなくなりました！カートを再確認ください！"
        break
      else
        OrderItem.create(user_id: current_user.id, product_id: cart_item.product.id,
                            order_id: @order.id, price: cart_item.product.price, quantity: cart_item.quantity_in_cart)
        cart_item.destroy
        cart_item.product.stock_quantity -= cart_item.quantity_in_cart
        cart_item.product.save
      end
    end
    @order_items = OrderItem.where(order_id: @order.id)
  end

end
