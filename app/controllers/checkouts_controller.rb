# frozen_string_literal: true

class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def create
    Payments::StripePayment::CreateSession.call(user: current_user) do |on|
      on.success { |session| redirect_to session.url, status: 303, allow_other_host: true }
      on.failure { |error| redirect_to cart_path, alert: error }
    end
  end

  def success
    Orders::CreateOrder.call(user: current_user) do |on|
      on.success { |order| redirect_to order_path(order.number), notice: 'Purchase was successful!' }
      on.failure { |error| redirect_to cart_path, alert: error }
    end
  end
end
