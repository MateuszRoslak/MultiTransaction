# frozen_string_literal: true

module Orders
  class CreateOrder < ApplicationService
    def initialize(user:)
      super()
      @user = user
    end

    def call
      line_items = user_line_items
      order = yield initialize_order(line_items)
      yield create_order_items(order, line_items)
      destroy_line_items

      Success order
    end

    private

    def user_line_items
      @user.line_items.includes(:product, :product_discount)
    end

    def initialize_order(line_items)
      order = @user.orders.new(order_params(line_items))
      order.save ? Success(order) : Failure(order.errors.messages)
    end

    def create_order_items(order, line_items)
      order_items = line_items.map { |line_item| order_list_params(line_item) }
      order_items = order.order_items.new(order_items)
      order.save ? Success(order_items) : Failure(order_items.errors.messages)
    end

    def destroy_line_items
      @user.line_items.destroy_all
    end

    def order_params(line_items)
      items_total = line_items.total_value - line_items.total_discount_value
      tax_total = line_items.total_tax_value - line_items.total_discount_tax_value
      {
        currency: 'pln',
        item_quantity: line_items.total_items,
        items_total:,
        items_total_net: items_total - tax_total,
        tax_total:,
        discount_total: line_items.total_discount_value,
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
