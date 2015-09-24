class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:cart_item][:product_id])
    asking_quantity = params[:cart_item][:quantity_in_cart].to_i
    cart_item = current_user.cart_items.find_or_initialize_by(product_id: product.id)

    cart_item.price_in_cart = product.price
    if (cart_item.quantity_in_cart + asking_quantity <= product.stock_quantity)
      cart_item.quantity_in_cart += asking_quantity
      flash[:success] = "#{product.title}を#{asking_quantity}個カートに追加しました！
      現在の#{product.title}の購入希望数は#{cart_item.quantity_in_cart}個です！"
      cart_item.create_lock_token
      cart_item.save
    else
      flash[:danger] = "#{product.title}は在庫数が不足しています！
      #{product.stock_quantity}個まで購入できます！"
    end

    @cart_items = current_user.cart_items
    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)
    return redirect_to cart_items_path
  end

  def index
    if current_user.nil?
      flash[:warning] = "サインインしてください！"
      return redirect_to signin_path
    else
      @cart_items = current_user.cart_items
      connect_token = ""
      @cart_items.includes(:product).each do |cart_item|
        if cart_item.price_in_cart != cart_item.product.price
          flash.now[:warning] = "#{cart_item.product.title}の価格が
          #{cart_item.price_in_cart}円から#{cart_item.product.price}円に変わりました！"
          cart_item.price_in_cart = cart_item.product.price
          cart_item.save
        end
        connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
      end
      @long_token = CartItem.encrypt(connect_token)
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    flash[:success] = "カートから#{cart_item.product.title}を削除しました！"
    cart_item.destroy
    return redirect_to cart_items_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    origin_quantity = cart_item.quantity_in_cart
    asking_quantity = params[:cart_item][:quantity_in_cart].to_i
    cart_item.quantity_in_cart = asking_quantity
    if asking_quantity <= cart_item.product.stock_quantity && cart_item.save
      cart_item.create_lock_token
      flash[:success] = "#{cart_item.product.title}の希望購入数を
      #{origin_quantity}個から#{asking_quantity}個に変更しました！"
    else
      flash[:danger] = "#{cart_item.product.title}は在庫数が不足しています！
      #{cart_item.product.stock_quantity}個まで購入できます！"
    end

    @cart_items = current_user.cart_items
    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)
    return redirect_to cart_items_path
  end

end
