class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :card_code, null: false
      t.string :card_type, null: false

      t.timestamps
    end
  end
end
