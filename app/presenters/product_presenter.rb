# frozen_string_literal: true

class ProductPresenter < ApplicationPresenter
  include ProductHelper

  def initialize(product)
    super()
    @product = product
  end

  def price_with_currency
    format_price(@product.currency, @product.default_price)
  end

  def price
    number_with_precision((@product.default_price.to_f / 100), precision: 2)
  end

  def created_at
    format_timestamp_to_db(@product.created_at)
  end

  def updated_at
    format_timestamp_to_db(@product.updated_at)
  end

  def currency
    @product.currency.upcase
  end

  def discounts_count
    @product.product_discounts.count
  end
end
