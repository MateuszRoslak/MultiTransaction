class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :country, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :building, null: false
      t.string :apartment, null: false
      t.string :zip_code, null: false
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
