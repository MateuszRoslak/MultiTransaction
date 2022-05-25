class Card < ApplicationRecord
  belongs_to :user

  validates :name, :card_code, :card_type, presence: true

  enum card_type: [:multisport, :ok_system], _prefix: true
end
