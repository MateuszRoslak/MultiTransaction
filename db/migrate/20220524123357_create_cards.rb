class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :card_code
      t.integer :card_type

      t.timestamps
    end
  end
end
