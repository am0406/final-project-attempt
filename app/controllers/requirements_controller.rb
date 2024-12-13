# app/controllers/requirements_controller.rb
require 'openai'
require 'dotenv/load'  

class RequirementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_requirement, only: [:show, :edit, :update, :destroy, :generate_meals]

  def index
    @requirements = current_user.requirements
  end

  def show
    @meals = @requirement.meals
  end

  def new
    
    @requirement = current_user.requirements.build
  end

  def create
    @requirement = current_user.requirements.build(requirement_params)
    if @requirement.save
      redirect_to @requirement, notice: "Requirement created!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @requirement.update(requirement_params)
      redirect_to @requirement, notice: "Requirement updated!"
    else
      render :edit
    end
  end

  def destroy
    @requirement.destroy
    redirect_to requirements_path, notice: "Requirement deleted."
  end

  # POST /requirements/:id/generate_meals
  def generate_meals
    openai_generate_meals(@requirement)
    redirect_to requirement_path(@requirement), notice: "AI meals generated!"
  end

  private

  def set_requirement
    @requirement = current_user.requirements.find(params[:id])
  end

  def requirement_params
    params.require(:requirement).permit(:name, :description)
  end

  def openai_generate_meals(requirement)
    
    client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])

    
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: "You are a helpful chef." },
          { role: "user", content: "Suggest a meal for someone with: #{requirement.name}" }
        ],
        temperature: 0.7
      }
    )

    raw_ai_text = response.dig("choices", 0, "message", "content") || "No response"

    #
    begin
      meal_data = JSON.parse(raw_ai_text)
      Meal.create!(
        user: requirement.user,
        requirement: requirement,
        name: meal_data["name"] || "AI Suggested Meal",
        instructions: meal_data["instructions"] || "No instructions provided."
      )
    rescue JSON::ParserError
      # If GPT didn't return valid JSON, store entire string
      Meal.create!(
        user: requirement.user,
        requirement: requirement,
        name: "Unparsed AI Meal",
        instructions: raw_ai_text
      )
    end
  end
end
