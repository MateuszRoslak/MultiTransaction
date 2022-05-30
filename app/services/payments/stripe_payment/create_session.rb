# frozen_string_literal: true

module Payments
  module StripePayment
    class CreateSession < ApplicationService
      include Dry::Transaction

      tee :params
      tee :create_line_items
      try :create_session, catch: StandardError

      def params(input)
        @user = input.fetch(:user)
      end

      def create_line_items
        @line_items = @user.line_items.includes(:product).map do |line_item|
          {
            quantity: line_item.quantity,
            price_data: {
              currency: line_item.product.currency,
              unit_amount: line_item.product.default_price,
              product_data: {
                name: line_item.product.name,
              },
            },
          }
        end
      end

      def create_session
        @session = Stripe::Checkout::Session.create({
          customer_email: @user.email,
          success_url: success_checkout_url,
          cancel_url: cart_url,
          line_items: @line_items,
          expires_at: Time.current.to_i + 3600,
          mode: :payment,
        })
      end
    end
  end
end
