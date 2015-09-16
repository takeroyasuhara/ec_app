class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:cart_item][:product_id])
    asking_quantity = params[:cart_item][:asking_quantity].to_i
    cart_item = current_user.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.asking_quantity += asking_quantity
    cart_item.asking_price = product.price
    cart_item.possible_quantity = cart_item.asking_quantity
    if (cart_item.asking_quantity <= product.stock_quantity) && cart_item.save
      flash[:success] = "#{product.title}をカートに追加しました"
    else
      flash[:danger] = "#{product.title}は在庫数が不足しています"
    end
    redirect_to cart_items_path
  end

  def index
    if current_user.nil?
      flash[:warning] = "サインインしてください！"
      redirect_to signin_path
    else
      @cart_items = current_user.cart_items
      @products = Product.joins(:cart_items).merge(@cart_items)

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
    end
  end

  def destroy
    CartItem.find(params[:id]).destroy
    flash[:success] = "カートから商品を削除しました"
    redirect_to cart_items_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    product = Product.find(cart_item.product_id)
    cart_item.possible_quantity = params[:cart_item][:possible_quantity]
    quantity = cart_item.possible_quantity
    cart_item.asking_quantity = quantity
    if quantity == nil
      flash[:danger] = "1以上の整数を入力してください"
    elsif quantity > product.stock_quantity
      flash[:danger] = "#{product.title}は在庫数が不足しています"
    elsif !cart_item.save
      flash[:danger] = "1以上の整数を入力してください"
    else
      flash[:success] = "#{product.title}の購入希望数を変更しました"
    end
    redirect_to cart_items_path
  end

end
