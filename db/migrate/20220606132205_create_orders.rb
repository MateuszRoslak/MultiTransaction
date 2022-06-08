# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :number, null: false, unique: true
      t.string :currency, null: false
      t.integer :item_quantity, null: false
      t.integer :items_total, null: false
      t.integer :items_total_net, null: false
      t.integer :tax_total, null: false
      t.integer :discount_total, null: false

      t.index %i[number], unique: true

      t.timestamps
    end
  end
end
