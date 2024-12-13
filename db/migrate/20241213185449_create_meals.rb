class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :requirement, null: false, foreign_key: true
      t.string :name
      t.text :instructions

      t.timestamps
    end
  end
end
