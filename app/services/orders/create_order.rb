# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Orders
  class CreateOrder < ApplicationService
    include Dry::Monads[:result, :do]
    class << self
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
    end

    def initialize(user:)
      super()
      @user = user
      @line_items = user.line_items
    end

    def call
      yield initialize_order
      yield create_order_items
      yield destroy_line_items

      Success @order
    end

    private

    def initialize_order
      @order = @user.orders.new(order_params)
      @order.save ? Success(@order) : Failure(@order.errors.messages)
    end

    def create_order_items
      order_items = @line_items.includes(:product, :product_discount).map { |line_item| order_list_params(line_item) }
      @order_items = @order.order_items.new(order_items)
      @order.save ? Success(@order_items) : Failure(@order_items.errors.messages)
    end

    def destroy_line_items
      Success @user.line_items.destroy_all
    end

    def order_params
      items_total = @line_items.total_value - @line_items.total_discount_value
      tax_total = @line_items.total_tax_value - @line_items.total_discount_tax_value
      {
        currency: 'pln',
        item_quantity: @line_items.total_items,
        items_total:,
        items_total_net: items_total - tax_total,
        tax_total:,
        discount_total: @line_items.total_discount_value,
        status: :unpaid,
      }
    end

    def order_list_params(line_item)
      price = line_item.price
      quantity = line_item.quantity
      {
        product_id: line_item.product.id,
        name: line_item.product.name,
        currency: line_item.product.currency,
        price:,
        quantity:,
        total: quantity * price,
        tax_total: quantity * line_item.tax_value,
      }
    end
  end
end
