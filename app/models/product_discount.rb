# frozen_string_literal: true

class ProductDiscount < ApplicationRecord
  belongs_to :product

  validates :discount, :card_type, :percent, presence: true
end
