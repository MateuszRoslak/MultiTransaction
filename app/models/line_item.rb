# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true
  validates :product, uniqueness: { scope: :user }

  scope :total_value, -> { joins(:product).sum('line_items.quantity * products.default_price') }
  scope :total_items, -> { sum(:quantity) }
end
