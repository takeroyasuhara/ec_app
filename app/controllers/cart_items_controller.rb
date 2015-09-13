class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:cart_item][:product_id])
    asking_quantity = params[:cart_item][:asking_quantity].to_i
    if current_user.cart_items.find_by(product_id: product.id)
      cart_item = current_user.cart_items.find_by(product_id: product.id)
      if (cart_item.asking_quantity + asking_quantity) > product.stock_quantity
        flash[:danger] = "在庫数が足りないため、#{product.title}をカートに入れることができません."
      else
        cart_item.asking_quantity += asking_quantity
        cart_item.possible_quantity = cart_item.asking_quantity
        cart_item.save
        flash[:success] = "#{product.title}の購入希望数を変更しました！"
      end
    else
      current_user.cart_items.create(product_id: product.id,
      asking_price: product.price, asking_quantity: asking_quantity, possible_quantity: asking_quantity)
      flash[:success] = "カートに商品を入れました！"
    end
    redirect_to cart_items_path
  end

  def index
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
                                    現在の価格は#{product.price}円です."
      elsif cart_item.asking_quantity > product.stock_quantity
        @notification_messages << "#{product.title}の在庫数が
                                    カート追加時の希望購入個数(#{cart_item.asking_quantity}個)以下となりました.
                                    現在の在庫数は#{product.stock_quantity}個です."
        cart_item.possible_quantity = product.stock_quantity
        cart_item.save
      end
    end
  end

  def destroy
    CartItem.find(params[:id]).destroy
    flash[:success] = "カートから商品を削除しました！"
    redirect_to cart_items_path
  end

  def update
    cart_item = CartItem.find(params[:id])
    product = Product.find(cart_item.product_id)
    cart_item.possible_quantity = params[:cart_item][:possible_quantity]
    quantity = cart_item.possible_quantity
    cart_item.asking_quantity = quantity
    if quantity == nil
      flash[:danger] = "購入希望数に1以上の整数を半角入力してください."
    elsif quantity > product.stock_quantity
      flash[:danger] = "在庫が足りません.#{product.title}は#{product.stock_quantity}個まで購入できます."
    elsif !cart_item.save
      flash[:danger] = "購入希望数に1以上の整数を半角入力してください."
    else
      flash[:success] = "#{product.title}の購入希望数を更新しました."
    end
    redirect_to cart_items_path
  end

  def confirmation
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
                                    現在の価格は#{product.price}円です."
      elsif cart_item.asking_quantity > product.stock_quantity
        @notification_messages << "#{product.title}の在庫数が
                                    カート追加時の希望購入個数(#{cart_item.asking_quantity}個)以下となりました.
                                    現在の在庫数は#{product.stock_quantity}個です."
        cart_item.possible_quantity = product.stock_quantity
        cart_item.save
      end
    end
  end

end
