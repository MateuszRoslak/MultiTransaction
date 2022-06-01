# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_line_items, only: [:show]
  before_action :set_line_item, only: %i[destroy update]

  def show
    Discounts::ApplyDiscountService.new(current_user).call
    @line_items = @line_items.order(:created_at)
  end

  def destroy
    @line_item.destroy!
    redirect_to cart_path
  end

  def update
    @line_item.update!(line_item_params)
    redirect_to cart_path
  end

  private

  def set_line_items
    @line_items = current_user.line_items.includes(:product)
  end

  def set_line_item
    @line_item = current_user.line_items.find(params[:id])
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end
end
