class OrdersController < ApplicationController

  def new
    @cart_items = CartItem.where(user_id: current_user.id)
    product_ids = "SELECT product_id FROM cart_items
                     WHERE  user_id = :current_user_id"
    @products = Product.where("id IN (#{product_ids})",
                              current_user_id: current_user.id)
    @order = Order.new
    @products.each do |product|
      cart_item = @cart_items.find_by(product_id: product.id)
      if cart_item.asking_price != product.price
        if Notification.where(cart_item_id: cart_item.id).count != 0
          notification = Notification.find_by(cart_item_id: cart_item.id)
          notification.price = product.price
          notification.save

        else
          Notification.create(cart_item_id: cart_item.id, asking_price: cart_item.asking_price,
            price: product.price, asking_quantity: cart_item.asking_quantity,
            stock_quantity: product.stock_quantity)
        end

      elsif cart_item.asking_quantity > product.stock_quantity
        if Notification.where(cart_item_id: cart_item.id).count != 0
          notification = Notification.find_by(cart_item_id: cart_item.id)
          notification.stock_quantity = product.stock_quantity
          notification.save

        else
          Notification.create(cart_item_id: cart_item.id, asking_price: cart_item.asking_price,
            price: product.price, asking_quantity: cart_item.asking_quantity,
            stock_quantity: product.stock_quantity)
        end
        cart_item.possible_quantity = product.stock_quantity
        cart_item.save
      elsif cart_item.asking_quantity <= product.stock_quantity
        if Notification.where(cart_item_id: cart_item.id).count != 0
          notification = Notification.find_by(cart_item_id: cart_item.id)
          notification.destroy
          cart_item.possible_quantity = cart_item.asking_quantity
          cart_item.save
        end
      end
    end
    cart_ids = "SELECT id FROM cart_items
                  WHERE user_id = :current_user_id"
    @notifications = Notification.where("cart_item_id IN (#{cart_ids})",
                              current_user_id: current_user.id)
    @addresses = Address.where(user_id: current_user.id)

  end


  def create
    @order = Order.new
    @order.address_text = params[:order][:address_text]
    cart_ids = "SELECT id FROM cart_items
                  WHERE user_id = :current_user_id"
    @notifications = Notification.where("cart_item_id IN (#{cart_ids})",
                              current_user_id: current_user.id)
    if @notifications.count != 0
      # 既に存在しているnotificationに更新があれば、通知を更新して再通知
      # 更新なくともstock_quantityが0なら注文処理はしない
      # 更新なくてstock_quantityが0でなければ注文処理実行
      @notifications.each do |notification|
        cart_id = notification.cart_item_id
        cart_item = CartItem.find_by(id: cart_id)
        ActiveRecord::Base.transaction do
        product = Product.find_by(id: cart_item.product_id).lock
          if notification.price != product.price || notification.stock_quantity != product.stock_quantity
            notification.price = product.price
            notification.stock_quantity = product.stock_quantity
            notification.save
          elsif notification.stock_quantity == 0
          else
            notification.destroy
            @order.save
            OrderItem.create(user_id: current_user.id, product_id: product.id,
                              order_id: @order.id,price: product.price, quantity: cart_item.possible_quantity)
            cart_item.destroy
            product.stock_quantity -= cart_item.possible_quantity
            product.save
          end
        end
        @notifications = Notification.where("cart_item_id IN (#{cart_ids})",
                                              current_user_id: current_user.id)
      end
      if @order
        @cart_items = CartItem.where(user_id: current_user.id)
        product_ids = "SELECT product_id FROM cart_items
                         WHERE  user_id = :current_user_id
                         AND possible_quantity != 0"
        ActiveRecord::Base.transaction do
          @products = Product.where("id IN (#{product_ids})",
                                    current_user_id: current_user.id).lock

          @products.each do |product|
            cart_item = @cart_items.find_by(product_id: product.id)
            OrderItem.create(user_id: current_user.id, product_id: product.id,
                              order_id: @order.id,price: product.price, quantity: cart_item.possible_quantity)
            cart_item.destroy
            product.stock_quantity -= cart_item.possible_quantity
            product.save
          end
        end
      else
        @order = Order.new
        @order.address_text = params[:order][:address_text]
        @order.save

        @cart_items = CartItem.where(user_id: current_user.id)
        product_ids = "SELECT product_id FROM cart_items
                           WHERE  user_id = :current_user_id
                           AND possible_quantity != 0"
        ActiveRecord::Base.transaction do
          @products = Product.where("id IN (#{product_ids})",
                                      current_user_id: current_user.id).lock

          @products.each do |product|
            cart_item = @cart_items.find_by(product_id: product.id)
            OrderItem.create(user_id: current_user.id, product_id: product.id,
                              order_id: @order.id,price: product.price, quantity: cart_item.possible_quantity)
            cart_item.destroy
            product.stock_quantity -= cart_item.possible_quantity
            product.save
          end
        end
      end
    else @notifications.count == 0

      @order = Order.new
      @order.address_text = params[:order][:address_text]

      @cart_items = CartItem.where(user_id: current_user.id)
      product_ids = "SELECT product_id FROM cart_items
                       WHERE  user_id = :current_user_id"
      ActiveRecord::Base.transaction do
        @products = Product.where("id IN (#{product_ids})",
                                  current_user_id: current_user.id)
        @products.each do |product|
          cart_item = @cart_items.find_by(product_id: product.id)
          if cart_item.asking_price != product.price # 通知する必要あれば通知
            Notification.create(cart_item_id: cart_item.id, asking_price: cart_item.asking_price,
              price: product.price, asking_quantity: cart_item.asking_quantity,
              stock_quantity: product.stock_quantity)
          elsif cart_item.possible_quantity > product.stock_quantity # 通知する必要あれば通知
            Notification.create(cart_item_id: cart_item.id, asking_price: cart_item.asking_price,
              price: product.price, asking_quantity: cart_item.asking_quantity,
              stock_quantity: product.stock_quantity)
          else # 通知する必要なければ購入処理
            @order.save
            OrderItem.create(user_id: current_user.id, product_id: product.id, order_id: @order.id,
                              price: product.price, quantity: cart_item.possible_quantity)

            cart_item.destroy
            product.stock_quantity -= cart_item.possible_quantity
            product.save
          end
        end
      end
      @notifications = Notification.where("cart_item_id IN (#{cart_ids})",
                                current_user_id: current_user.id)
    end
    if @order != nil
      @order_items = OrderItem.where(order_id: @order.id)
    end
  end
end
