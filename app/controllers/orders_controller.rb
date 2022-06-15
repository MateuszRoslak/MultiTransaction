# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_orders, only: [:index]
  before_action :set_order, only: [:show]

  def index; end

  def show; end

  private

  def set_orders
    @orders = current_user.orders.order(created_at: :desc)
  end

  def set_order
    @order = current_user.orders.find_by(number: params[:id])
  end
end
