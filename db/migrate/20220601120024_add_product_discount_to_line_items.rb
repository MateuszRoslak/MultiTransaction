# frozen_string_literal: true

class AddProductDiscountToLineItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :line_items, :product_discount, foreign_key: true, null: true
  end
end
