# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!

  before_action :build_cart, only: %i[show summary]
  before_action :set_line_item, only: %i[destroy update]

  def show; end

  def summary; end

  def destroy
    @line_item.destroy!
    redirect_to cart_path
  end

  def update
    @line_item.update!(line_item_params)
    redirect_to cart_path
  end

  private

  def set_line_item
    @line_item = current_user.line_items.find(params[:id])
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end

  def build_cart
    Carts::BuildCart.new(user: current_user).call do |on|
      on.success { |cart| @cart = cart }
      on.failure { |error| flash[:alert] = error }
    end
  end
end
