# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, foreign_key: true
      t.string :name, null: false
      t.string :currency, null: false
      t.integer :price, null: false
      t.integer :quantity, null: false
      t.integer :total, null: false
      t.integer :tax_total, null: false

      t.timestamps
    end
  end
end
