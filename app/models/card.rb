# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :user

  validates :name, :card_code, :card_type, presence: true

  #enum card_type: %i[multisport ok_system], _prefix: true
end
