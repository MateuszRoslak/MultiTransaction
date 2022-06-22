# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  before_action :set_products, only: [:index]
  before_action :set_product, only: %i[show add_to_cart]

  def index
    @q = Product.all.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
  end

  def show; end

  def add_to_cart
    line_item = current_user.line_items.new(product: @product, **product_params)

    if line_item.save
      flash[:notice] = "Successfully added #{@product.name} to the cart!"
    else
      flash[:alert] = 'The product is already in the cart'
    end

    redirect_to products_path
  end

  private

  def set_products
    @products = Product.where(active: true)
  end

  def set_product
    @product = Product.find_by(id: params[:id], active: true)
  end

  def product_params
    params.require(:product).permit(:quantity)
  end
end
