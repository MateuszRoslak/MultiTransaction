# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Orders
  class CreateOrder < ApplicationService
    include CartHelper
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
      {
        currency: 'pln',
        item_quantity: @line_items.total_items,
        items_total: get_final_price(@line_items),
        items_total_net: get_final_net(@line_items),
        tax_total: get_final_tax(@line_items),
        discount_total: @line_items.total_discount_value,
      }
    end

    def order_list_params(line_item)
      price = get_line_item_price(line_item)
      quantity = line_item.quantity
      {
        product_id: line_item.product.id,
        name: line_item.product.name,
        currency: line_item.product.currency,
        price: get_line_item_price(line_item),
        quantity:,
        total: quantity * price,
        tax_total: quantity * get_line_item_tax(line_item),
      }
    end
  end
end
