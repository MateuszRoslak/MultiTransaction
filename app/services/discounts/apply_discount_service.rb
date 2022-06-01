module Discounts
  class ApplyDiscountService < ApplicationService
    attr_reader :user

    def initialize(user)
      @user = user
      @line_items = @user.line_items
    end

    def call
      @line_items.each do |line_item|
        best_discount = line_item.product.product_discounts.join_user_discounts(@user).order(:discount_price).first
        line_item.update!(product_discount_id: best_discount.id) if best_discount.present?
      end
    end
  end
end