# frozen_string_literal: true

class Product < ApplicationRecord
  include HasTaxesCalculation

  before_validation -> { calculate_tax_value(default_price) }

  has_many :product_discounts, dependent: :destroy
  has_many :line_items, dependent: :destroy

  validates :name, :default_price, :currency, :quantity, :active, presence: true
end
