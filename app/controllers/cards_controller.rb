# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_cards, only: [:index]
  before_action :set_card, only: %i[show destroy]

  def index; end

  def create
    @card = current_user.cards.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_path, notice: 'Card was successfully added' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "#{helpers.dom_id(@card)}_form",
            partial: 'form',
            locals: { card: @card }
          )
        end
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
