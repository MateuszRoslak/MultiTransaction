# frozen_string_literal: true

class CartPresenter < ApplicationPresenter
  include ProductHelper

  def initialize(cart)
    super()
    @cart = cart
  end

  def final_discount
    format_price(@cart.currency, @cart.final_discount)
  end

  def final_net
    format_price(@cart.currency, @cart.final_net)
  end

  def final_tax
    format_price(@cart.currency, @cart.final_tax)
  end

  def final_price
    format_price(@cart.currency, @cart.final_price)
  end
end
