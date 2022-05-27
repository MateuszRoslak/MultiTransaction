# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :default_price, null: false
      t.string :currency, null: false
      t.text :description
      t.integer :quantity, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
