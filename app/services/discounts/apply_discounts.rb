# frozen_string_literal: true

module Discounts
  class ApplyDiscounts < ApplicationService
    def initialize(user:)
      super()
      @user = user
      @line_items = @user.line_items
    end

    def call
      include_discounts
    end

    private

    def include_discounts
      @line_items.each do |line_item|
        best_discount = line_item.product.product_discounts.join_user_discounts(@user).order(:discount_price).first
        if best_discount.present?
          line_item.update!(product_discount_id: best_discount.id)
        else
          line_item.update!(product_discount_id: nil)
        end
      end
    end
  end
end
