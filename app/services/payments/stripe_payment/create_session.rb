# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Payments
  module StripePayment
    class CreateSession < ApplicationService
      include CartHelper
      include Rails.application.routes.url_helpers
      include Dry::Monads[:result, :do]
      class << self
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      end

      def initialize(user:)
        super()
        @user = user
      end

      def call
        yield create_customer
        yield create_line_items
        create_session
      end

      private

      def create_customer
        @customer = @user.customers.find_by(processor: :stripe)
        unless @customer.present?
          stripe_customer = Stripe::Customer.create({ email: @user.email, name: user_name })
          @customer = @user.customers.create!(processor: :stripe, processor_id: stripe_customer.id)
        end

        Success @customer
      end

      def create_line_items
        @line_items = @user.line_items.includes(:product, :product_discount).map do |line_item|
          {
            quantity: line_item.quantity,
            price_data: {
              currency: line_item.product.currency,
              unit_amount: get_line_item_price(line_item),
              product_data: {
                name: line_item.product.name,
              },
            },
          }
        end
        @line_items ? Success(@line_items) : Failure('Your shopping cart is empty')
      end

      def create_session
        Success Stripe::Checkout::Session.create(
          {
            customer: @customer.processor_id,
            success_url: success_checkout_url,
            cancel_url: cart_url,
            line_items: @line_items,
            expires_at: Time.current.to_i + 3600,
            mode: :payment,
          }
        )
      end

      def user_name
        "#{@user.first_name} #{@user.last_name}"
      end

      def default_url_options
        Rails.application.config.action_mailer.default_url_options
      end
    end
  end
end
