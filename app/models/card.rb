class Card < ApplicationRecord
  belongs_to: user

  enum card_type: [:multisport, :ok_system], _prefix: true
end
