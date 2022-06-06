# frozen_string_literal: true

class ChangeProductDiscounts < ActiveRecord::Migration[7.0]
  def change
    add_column :product_discounts, :discount_price, :integer, null: false
    remove_column :product_discounts, :percent
    remove_column :product_discounts, :discount
  end
end
