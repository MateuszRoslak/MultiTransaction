# frozen_string_literal: true

module UserCardsHelper
  def get_user_cards(user)
    user.cards.pluck(:name)
  end
end
