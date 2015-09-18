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
  end

  def destroy
    CartItem.find(params[:id]).destroy
    flash[:success] = "カートから商品を削除しました"
    redirect_to cart_items_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    product = Product.find(cart_item.product_id)
    begin
      CartItem.transaction do
        cart_item.lock_version = params[:cart_item][:lock_version]
        cart_item.asking_quantity = params[:cart_item][:asking_quantity]
        if cart_item.asking_quantity <= product.stock_quantity && cart_item.save
          flash[:success] = "#{product.title}をカートに追加しました"
        else
          flash[:danger] = "#{product.title}は在庫数が不足しています"
        end
      end
    rescue ActiveRecord::StaleObjectError
      flash[:danger] = "カート内は変更されています"
    end
    redirect_to cart_items_path
  end


  private

  def cart_item_params
    params.require(:cart_item).permit(:asking_price, :asking_quantity, :lock_version)
  end

end
