Rails.application.routes.draw do
  devise_for :users
  resources :requirements do
    member do
      post :generate_meals
    end
  end
  # this extra member stuff is for the button instead of automatic generation (pls don't spam the button I have little money)
  resources :meals, only: [:index, :show, :destroy]
  # maybe ill take out everything after meals if this doesn't work
  
  root "pages#home"
end
