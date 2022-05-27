# frozen_string_literal: true

class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :balance, null: false, default: 0
      t.string :currency, null: false

      t.timestamps
    end
  end
end
