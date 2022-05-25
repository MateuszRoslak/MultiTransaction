class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer

    @checkout_session = current_user
                          .payment_processor
                          .checkout(
                            mode: :payment,
                            line_items: params[:line_items],
                            success_url: success_checkout_url,
                            expires_at: Time.now.to_i + 3600
                          )
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
  end

  def history
    @line_items = Stripe::PaymentIntent.list({ customer: current_user.payment_processor.customer.id})
  end

  def order
    @payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_id])
    @session = Stripe::Checkout::Session.list({ payment_intent: @payment_intent.id }).first
    @line_items = Stripe::Checkout::Session.list_line_items(@session.id)
  end

end