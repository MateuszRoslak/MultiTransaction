# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_line_items, only: [:show]
  before_action :set_line_item, only: [:destroy]

  def show; end

  def destroy
    @line_item.destroy!
    redirect_to cart_path
  end

  private

  def set_line_items
    @line_items = current_user.line_items.includes(:product)
  end

  def set_line_item
    @line_item = current_user.line_items.find(params[:id])
  end
end
