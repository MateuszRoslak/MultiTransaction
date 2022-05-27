# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, :currency, presence: true
end
