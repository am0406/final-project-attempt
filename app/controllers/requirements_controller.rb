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

  
  def generate_meals
    openai_generate_meals(@requirement)
    pp @resp
    ml = Meal.create
    ml.user_id = current_user.id
    ml.requirement_id = @requirement.id
    ml.instructions = @resp
    ml.name = "meal"
    ml.save

    @meals = Meal.where({:user=> current_user.id})
    render({ :template => "meals/index" })
  end

  private

  def set_requirement
    @requirement = current_user.requirements.find(params[:id])
  end

  def requirement_params
    params.require(:requirement).permit(:name, :description)
  end

  def openai_generate_meals(requirement)
    request_headers_hash = {
      "Authorization" => "Bearer ENV['OPENAI_API_KEY'],
      "content-type" => "application/json"
    }

    request_body_hash = {
      "model" => "gpt-3.5-turbo",
      "messages" => [
        {
          "role" => "system",
          "content" => "You are a helpful chef."
        },
        {
          "role" => "user",
          "content" => "Suggest a meal for someone with: #{requirement.name}"
        }
      ]
    }

    request_body_json = JSON.generate(request_body_hash)

    raw_response = HTTP.headers(request_headers_hash).post(
      "https://api.openai.com/v1/chat/completions",
      :body => request_body_json
    ).to_s

    parsed_response = JSON.parse(raw_response)

    @resp= parsed_response["choices"][0]["message"]["content"]
  end
end
