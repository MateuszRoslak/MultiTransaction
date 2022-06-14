# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_order, only: [:retry]

  def create
    Payments::StripePayment::CreateSession.new(user: current_user).call do |on|
      on.success { |session| redirect_to session.url, status: 303, allow_other_host: true }
      on.failure { |error| redirect_to cart_path, alert: error }
    end
  end

  def retry
    Payments::StripePayment::RetrySession.new(order: @order).call do |on|
      on.success { |session| redirect_to session.url, status: 303, allow_other_host: true }
      on.failure { |error| redirect_to orders_path, alert: error }
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end
end
