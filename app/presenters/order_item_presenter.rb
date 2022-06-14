# frozen_string_literal: true

class OrderItemPresenter < ApplicationPresenter
  include ProductHelper

  def initialize(order_item)
    super()
    @order_item = order_item
  end

  def price
    format_price(@order_item.currency, @order_item.price)
  end

  def total_price
    format_price(@order_item.currency, @order_item.total)
  end
end
