class CartItemsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

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
    @cart_items = current_user.cart_items
    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
        if cart_item.price_in_cart != cart_item.product.price && cart_item.price_in_cart != 0
        flash.now[:warning] = "カート内の商品価格に変更がありました。カート内の商品を確認ください！"
      end
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)
  end

  def destroy
    @cart_item.destroy
    flash[:success] = "カートから#{@cart_item.product.title}を削除しました！"
    redirect_to cart_items_path
  end

  def update
    cart_item = current_user.cart_items.find_or_initialize_by(product_id: params[:cart_item][:product_id])
    origin_quantity = cart_item.quantity_in_cart
    asking_quantity = params[:cart_item][:quantity_in_cart].to_i
    cart_item.quantity_in_cart = asking_quantity

    if asking_quantity > cart_item.product.stock_quantity
      flash[:danger] = "#{cart_item.product.title}は在庫数が不足しています！
                        #{cart_item.product.title}は#{cart_item.product.stock_quantity}個まで購入できます."
    elsif !cart_item.save
      flash[:danger] = "購入希望数に1以上の整数を半角入力してください."
    else
      cart_item.create_lock_token
      flash[:success] = "#{cart_item.product.title}の希望購入数を
                        #{origin_quantity}個から#{asking_quantity}個に変更しました！"
    end
    @cart_items = current_user.cart_items
    connect_token = ""
    @cart_items.includes(:product).each do |cart_item|
      connect_token += (cart_item.lock_token + cart_item.quantity_in_cart.to_s + cart_item.product.price.to_s)
    end
    @long_token = CartItem.encrypt(connect_token)
    return redirect_to cart_items_path
  end

  private
    def correct_user
      @cart_item = current_user.cart_items.find(params[:id])
    rescue
      redirect_to cart_items_path
    end

end
