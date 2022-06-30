# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_orders, only: [:index]
  before_action :set_order, only: [:show]

  def index
    @query = current_user.orders.ransack(params[:query])
    @orders = @query.result(distinct: true).paginate(page: params[:page], per_page: params[:per_page])
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
