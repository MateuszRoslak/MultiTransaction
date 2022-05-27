# frozen_string_literal: true

class CreateProductDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :product_discounts do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :discount, null: false, default: 0
      t.string :card_type, null: false
      t.boolean :percent, null: false, default: false

      t.timestamps
    end
  end
end
