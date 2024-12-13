class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal, only: [:show, :destroy]

  def index
    @meals = current_user.meals
  end

  def show
  end

  def destroy
    @meal.destroy
    redirect_to meals_path, notice: "Meal deleted."
  end

  private

  def set_meal
    @meal = current_user.meals.find(params[:id])
  end
  
end
