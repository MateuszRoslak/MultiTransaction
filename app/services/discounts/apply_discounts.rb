# frozen_string_literal: true

module Discounts
  class ApplyDiscounts < ApplicationService
    def initialize(user:)
      super()
      @user = user
    end

    def call
      line_items = user_line_items
      include_discounts(line_items)
    end

    private

    def user_line_items
      @user.line_items.includes(:user, :product, :product_discount)
    end

    def include_discounts(line_items)
      line_items.each do |line_item|
        best_discount = line_item.product.product_discounts.join_user_discounts(@user).order(:discount_price).first
        if best_discount.present? && (best_discount.discount_price < line_item.product.default_price)
          line_item.update!(product_discount_id: best_discount.id)
        else
          line_item.update!(product_discount_id: nil)
        end
      end

      Success line_items
    end
  end
end
