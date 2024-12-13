class AddIngredientsToMeals < ActiveRecord::Migration[7.1]
  def change
    add_column :meals, :ingredients, :text
  end
end
