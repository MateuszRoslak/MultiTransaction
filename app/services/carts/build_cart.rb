# frozen_string_literal: true

module Carts
  class BuildCart < ApplicationService
    def initialize(user:)
      super()
      @user = user
    end

    def call
      line_items = yield apply_discounts
      create_structure
      build_cart_object(line_items)
    end

    private

    def apply_discounts
      Discounts::ApplyDiscounts.new(user: @user).call do |on|
        on.success { |line_items| Success line_items }
        on.failure { |error| Failure error }
      end
    end

    def create_structure
      Struct.new(
        'Cart',
        :currency,
        :total_items,
        :final_net,
        :final_tax,
        :final_price,
        :final_discount,
        :line_items,
        keyword_init: true
      )
    end

    def build_cart_object(line_items)
      cart_params = { line_items: [] }

      if line_items.present?
        final_price = line_items.total_value - line_items.total_discount_value
        final_tax = line_items.total_tax_value - line_items.total_discount_tax_value

        cart_params.merge!(
          {
            currency: line_items.first.product.currency,
            total_items: line_items.total_items,
            final_net: final_price - final_tax,
            final_tax:,
            final_price:,
            final_discount: line_items.total_discount_value,
            line_items:,
          }
        )
      end
      Success Struct::Cart.new(cart_params)
    end
  end
end
