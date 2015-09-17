class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:cart_item][:product_id])
    asking_quantity = params[:cart_item][:asking_quantity].to_i
    cart_item = current_user.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.asking_quantity += asking_quantity
    cart_item.asking_price = product.price
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
    cart_item.asking_quantity = params[:cart_item][:asking_quantity]
    quantity = cart_item.asking_quantity
    if quantity <= product.stock_quantity && cart_item.save
      flash[:success] = "#{product.title}の購入希望数を変更しました"
    elsif quantity > product.stock_quantity
      flash[:danger] = "#{product.title}は在庫数が不足しています"
    else
      flash[:danger] = "1以上の整数を入力してください"
    end
    redirect_to cart_items_path
  end

end
