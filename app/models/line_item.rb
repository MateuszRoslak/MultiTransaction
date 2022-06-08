# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :product_discount, optional: true

  validates :quantity, presence: true
  validates :product, uniqueness: { scope: :user }

  scope :total_value, -> { joins(:product).sum('line_items.quantity * products.default_price') }
  scope :total_tax_value, -> { joins(:product).sum('line_items.quantity * products.tax_value') }

  scope :total_discount_value,
        lambda {
          joins(:product_discount, :product)
            .sum('line_items.quantity * (products.default_price - product_discounts.discount_price)')
        }
  scope :total_discount_tax_value,
        lambda {
          joins(:product_discount, :product)
            .sum('line_items.quantity * (products.tax_value - product_discounts.tax_value)')
        }
  scope :total_items, -> { sum(:quantity) }
end
