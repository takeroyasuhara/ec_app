class OrdersController < ApplicationController
  def create

    @cart_items = CartItem.where(user_id: current_user.id)
    product_ids = "SELECT product_id FROM cart_items
                     WHERE  user_id = :current_user_id"
    @products = Product.where("id IN (#{product_ids})",
                              current_user_id: current_user.id)

    @notification_messages = []

    @products.each do |product|
      cart_item = @cart_items.find_by(product_id: product.id)
      if cart_item.asking_price != product.price
        @notification_messages << "#{product.title}の商品価格が
                                  カート追加時(#{cart_item.asking_price}円)から変更されています.
                                  現在の価格は#{product.price}円です.カート内の商品を再確認ください."

      elsif cart_item.asking_quantity > product.stock_quantity
        @notification_messages << "#{product.title}の在庫数が
                                  カート追加時の希望購入個数(#{cart_item.asking_quantity}個)以下となりました.
                                  現在の在庫数は#{product.stock_quantity}個です.カート内の商品を再確認ください."
        cart_item.possible_quantity = product.stock_quantity
        cart_item.save
      end
    end

    # order_items = @products.where(stock_quantity != 0)

    if @notification_messages == nil

      @products.each do |product|
        cart_item = @cart_items.find_by(product_id: product.id)

        @order = Order.new
        @order.address_text = params[:order][:address_text]
        @order.save
        OrderItem.create(user_id: current_user.id, product_id: product.id, order_id: @order.id,
                          price: product.price, quantity: cart_item.possible_quantity)

        cart_item.destroy
        product.stock_quantity -= cart_item.possible_quantity
        product.save
      end
      flash.now[:success] = "注文処理が完了しました!"
    end
  end

end
