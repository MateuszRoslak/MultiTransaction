# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :set_cards, only: [:show]
  before_action :set_card, only: %i[destroy]

  def show; end

  def create
    @card = current_user.cards.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_path, notice: 'Card was successfully added' }
      else
        format.turbo_stream
      end
    end
  end

  def new
    @card = current_user.cards.new
  end

  def destroy
    @card.destroy!
    redirect_to cards_path
  end

  private

  def set_cards
    @cards = current_user.cards
  end

  def set_card
    @card = current_user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:name, :card_type, :card_code)
  end
end
