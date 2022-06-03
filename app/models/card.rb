# frozen_string_literal: true

class Card < ApplicationRecord
  include CardTypeEnum

  belongs_to :user

  validates :name, :card_code, :card_type, presence: true

  enum card_type: CardTypeEnum::VALUES, _prefix: true
end
