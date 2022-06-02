# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    Payments::StripePayment::CreateSession.call(user: current_user) do |on|
      on.success { |session| redirect_to session.url, status: 303, allow_other_host: true }
      on.failure do |error|
        flash[:alert] = error
        redirect_to cart_path
      end
    end
  end

  def success
    # TODO: After creating the transaction history model, add the purchase summary screen
    current_user.line_items.destroy_all

    flash[:notice] = 'Purchase was successful!'
    redirect_to cart_path
  end
end
