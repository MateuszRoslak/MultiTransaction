# frozen_string_literal: true

require 'dry/matcher/result_matcher'

module Payments
  module StripePayment
    class RetrySession < ApplicationService
      include Dry::Monads[:result, :do]
      class << self
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
      end

      def initialize(order:)
        super()
        @order = order
      end

      def call
        yield check_order
        retry_session
      end

      private

      def check_order
        @order.status_unpaid? && @order.session.present? ? Success(@order) : Failure('The session has expired')
      end

      def retry_session
        Success Stripe::Checkout::Session.retrieve(@order.session)
      end
    end
  end
end
