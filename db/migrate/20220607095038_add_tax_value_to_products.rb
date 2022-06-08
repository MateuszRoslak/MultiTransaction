# frozen_string_literal: true

class AddTaxValueToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :tax_value, :integer, null: false
    add_column :product_discounts, :tax_value, :integer, null: false
  end
end
