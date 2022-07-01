# frozen_string_literal: true

module Admin
  class ProductsController < AdminController
    before_action :set_product, only: %i[update edit destroy toggle_active]
    before_action :build_products, only: %i[index]

    def index; end

    def edit; end

    def destroy
      @product.destroy!

      respond_to do |format|
        build_products
        flash.now[:notice] = "Successful deleted #{@product.name}"
        format.turbo_stream { render :update }
      end
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html { redirect_to admin_products_path, notice: "#{@product.name} was successfully added" }
        else
          format.turbo_stream { render :form_update, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to admin_products_path, notice: "Successful updated #{@product.name}" }
        else
          format.turbo_stream { render :form_update, status: :unprocessable_entity }
        end
      end
    end

    def toggle_active
      @product.update!(active: params[:active])

      respond_to do |format|
        build_products
        flash.now[:notice] = "Successful updated #{@product.name}"
        format.turbo_stream { render :update }
      end
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :quantity, :description, :currency, :default_price, :active)
    end

    def build_products
      Admin::Products::BuildProducts.new.call do |on|
        on.success { |products| @products = products }
        on.failure { |error| flash.now[:alert] = error }
      end
    end
  end
end
