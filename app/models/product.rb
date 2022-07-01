# frozen_string_literal: true

class Product < ApplicationRecord
  include HasTaxesCalculation
  attribute :default_price, PriceType.new

  before_validation -> { calculate_tax_value(default_price) if default_price }

  has_many :product_discounts, dependent: :destroy
  has_many :line_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  validates :name, :default_price, :currency, :quantity, presence: true
  validates :active, inclusion: [true, false]

  enum currency: { pln: 'pln' }, _prefix: true
end
