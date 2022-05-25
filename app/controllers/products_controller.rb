class ProductsController < ApplicationController
  def index
    @products_list = Stripe::Product.list({})
  end

  def show
    @product = Stripe::Product.retrieve(params[:id])
  end

end
