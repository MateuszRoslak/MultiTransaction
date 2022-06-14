# frozen_string_literal: true

module HasTaxesCalculation
  extend ActiveSupport::Concern
  TAX_PERCENT = 23

  included do
    validates :tax_value, presence: true
  end

  private

  def calculate_tax_value(gross_price)
    net_price = gross_price / (1 + (TAX_PERCENT / 100.0))
    self.tax_value = (gross_price - net_price).ceil
  end
end
