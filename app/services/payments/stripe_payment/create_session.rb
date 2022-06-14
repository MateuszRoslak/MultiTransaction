# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Payments
  module StripePayment
    class CreateSession < ApplicationService
      include Rails.application.routes.url_helpers
      include Dry::Monads[:result, :do]
      class << self
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      end

      def initialize(user:, order:)
        super()
        @user = user
        @order = order
      end

      def call
        customer = yield create_customer
        line_items = yield create_line_items
        session = yield create_session(customer, line_items)

        yield update_order(session)
        Success session
      end

      private

      def create_customer
        customer = @user.customers.find_by(processor: :stripe)
        unless customer.present?
          stripe_customer = Stripe::Customer.create({ email: @user.email, name: user_name })
          customer = @user.customers.create!(processor: :stripe, processor_id: stripe_customer.id)
        end

        Success customer
      end

      def create_line_items
        line_items = @order.order_items.map do |order_item|
          {
            quantity: order_item.quantity,
            price_data: {
              currency: order_item.currency,
              unit_amount: order_item.price,
              product_data: {
                name: order_item.product.name,
              },
            },
          }
        end
        line_items ? Success(line_items) : Failure('Your shopping cart is empty')
      end

      def create_session(customer, line_items)
        Success Stripe::Checkout::Session.create(
          {
            customer: customer.processor_id,
            success_url: order_url(@order.number),
            cancel_url: cart_url,
            line_items:,
            expires_at: Time.current.to_i + 3600,
            mode: :payment,
          }
        )
      end

      def update_order(session)
        @order.update(session: session.id)
        @order.errors.any? ? Failure(@order.errors.messages) : Success(@order)
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
