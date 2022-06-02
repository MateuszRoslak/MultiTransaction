# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :processor, null: false
      t.string :processor_id
      t.boolean :default
      t.json :data

      t.timestamps
    end

    add_index :customers, %i[processor processor_id], unique: true
  end
end
