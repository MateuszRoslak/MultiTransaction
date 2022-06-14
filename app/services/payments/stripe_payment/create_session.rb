# frozen_string_literal: true

module Payments
  module StripePayment
    class CreateSession < ApplicationService
      include Rails.application.routes.url_helpers

      def initialize(user:)
        super()
        @user = user
      end

      def call
        order = yield create_order
        customer = yield create_customer
        line_items = yield create_line_items(order)
        session = yield create_session(customer, line_items, order)

        yield update_order(order, session)
        Success session
      end

      private

      def create_order
        Orders::CreateOrder.new(user: @user).call do |on|
          on.success { |order| Success order }
          on.failure { |error| Failure error }
        end
      end

      def create_customer
        customer = @user.customers.find_by(processor: :stripe)
        unless customer.present?
          stripe_customer = Stripe::Customer.create({ email: @user.email, name: user_name })
          customer = @user.customers.create!(processor: :stripe, processor_id: stripe_customer.id)
        end

        Success customer
      end

      def create_line_items(order)
        line_items = order.order_items.map do |order_item|
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

      def create_session(customer, line_items, order)
        Success Stripe::Checkout::Session.create(
          {
            customer: customer.processor_id,
            success_url: order_url(order.number),
            cancel_url: cart_url,
            line_items:,
            expires_at: Time.current.to_i + 3600,
            mode: :payment,
          }
        )
      end

      def update_order(order, session)
        order.update(session: session.id)
        order.errors.any? ? Failure(order.errors.messages) : Success(order)
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
