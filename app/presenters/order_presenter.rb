# frozen_string_literal: true

class OrderPresenter < ApplicationPresenter
  include ProductHelper

  def initialize(order)
    super()
    @order = order
  end

  def date
    format_timestamp_to_db(@order.created_at)
  end

  def status
    @order.status.capitalize
  end

  def items_total
    format_price(@order.currency, @order.items_total)
  end

  def discount_total
    format_price(@order.currency, @order.discount_total)
  end

  def items_total_net
    format_price(@order.currency, @order.items_total_net)
  end

  def tax_total
    format_price(@order.currency, @order.tax_total)
  end
end
