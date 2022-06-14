# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true

  validates :name, :currency, :price, :quantity, :total, :tax_total, presence: true
end
