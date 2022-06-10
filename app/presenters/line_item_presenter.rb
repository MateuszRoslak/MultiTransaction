# frozen_string_literal: true

class LineItemPresenter < ApplicationPresenter
  include ProductHelper

  def initialize(line_item)
    super()
    @line_item = line_item
  end

  def normal_price
    format_price(@line_item.product.currency, @line_item.product.default_price)
  end

  def discount_price
    format_price(@line_item.product.currency, @line_item.product_discount&.discount_price)
  end

  def total_price
    format_price(@line_item.product.currency, @line_item.price * @line_item.quantity)
  end

  def product_name
    @line_item.product.name
  end

  def cart_type
    @line_item.product_discount&.card_type
  end

  def price
    format_price(@line_item.product.currency, @line_item.price)
  end
end
