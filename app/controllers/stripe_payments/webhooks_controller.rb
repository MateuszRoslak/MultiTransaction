# frozen_string_literal: true

module StripePayments
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    # rubocop:disable Metrics/AbcSize
    def process_event
      webhook_key = Rails.application.credentials.stripe.webhook_key

      payload = request.body.read
      if webhook_key.empty?
        data = JSON.parse(payload, symbolize_names: true)
        event = Stripe::Event.construct_from(data)
      else
        # Retrieve the event by verifying the signature using the raw body and secret if webhook signing exists
        sig_header = request.env['HTTP_STRIPE_SIGNATURE']

        begin
          event = Stripe::Webhook.construct_event(
            payload, sig_header, webhook_key
          )
        rescue JSON::ParserError
          log_error('Invalid payload')
          status 400
          return
        rescue Stripe::SignatureVerificationError
          log_error('Webhook signature verification failed.')
          status 400
          return
        end
      end

      event_type = event['type']
      data = event['data']
      data_object = data['object']

      case event_type
      when 'checkout.session.completed'
        Order.find_by(session: data_object['id']).update!(status: :paid)
      when 'checkout.session.expired'
        Order.find_by(session: data_object['id']).update!(status: :expired)
      end

      head :ok
    end
    # rubocop:enable Metrics/AbcSize
  end
end
