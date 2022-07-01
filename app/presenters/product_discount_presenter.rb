# frozen_string_literal: true

class ProductDiscountPresenter < ApplicationPresenter
  include ProductHelper

  def initialize(product_discount)
    super()
    @product_discount = product_discount
  end

  def price_with_currency
    format_price(@product_discount.product.currency, @product_discount.discount_price)
  end

  def created_at
    format_timestamp_to_db(@product_discount.created_at)
  end
end
