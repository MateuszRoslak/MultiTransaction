# frozen_string_literal: true

module Payments
  module StripePayment
    class RetrySession < ApplicationService
      def initialize(order:)
        super()
        @order = order
      end

      def call
        yield check_order
        session = retrieve_session
        check_session(session)
      end

      private

      def check_order
        @order.status_unpaid? && @order.session.present? ? Success(@order) : Failure('The session has expired')
      end

      def retrieve_session
        Stripe::Checkout::Session.retrieve(@order.session)
      end

      def check_session(session)
        session_status = session['status']

        case session_status
        when 'open'
          Success session
        when 'expired'
          @order.update!(status: :expired)
          Failure('The session has expired')
        when 'complete'
          @order.update!(status: :paid)
          Failure('The order has already been paid for')
        else
          Failure('The order cannot be paid for')
        end
      end
    end
  end
end
