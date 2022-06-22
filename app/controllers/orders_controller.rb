# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_orders, only: [:index]
  before_action :set_order, only: [:show]

  def index
    @q = current_user.orders.ransack(params[:q])
    @orders = @q.result(distinct: true).paginate(page: params[:page], per_page: 10)
  end

  def show; end

  private

  def set_orders
    @orders = current_user.orders.order(created_at: :desc)
  end

  def set_order
    @order = current_user.orders.find_by(number: params[:id])
  end
end
