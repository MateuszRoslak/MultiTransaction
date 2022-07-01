# frozen_string_literal: true

module Admin
  class ProductDiscountsController < AdminController
    before_action :set_product
    before_action :set_product_discounts, only: %i[index destroy create]
    before_action :set_product_discount, only: %i[destroy]

    def index
      @product_discount = @product.product_discounts.new
    end

    def create
      @product_discount = @product.product_discounts.new(product_discount_params)

      respond_to do |format|
        if @product_discount.save
          @product_discount = @product.product_discounts.new
          format.turbo_stream { render :form_update, status: :ok }
        else
          format.turbo_stream { render :form_update, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @product_discount.destroy

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def product_discount_params
      params.require(:product_discount).permit(:card_type, :discount_price)
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_product_discount
      @product_discount = ProductDiscount.find(params[:id])
    end

    def set_product_discounts
      @product_discounts = @product.product_discounts.order(created_at: :desc).includes(:product)
    end
  end
end
