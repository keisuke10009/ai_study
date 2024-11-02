Rails.application.routes.draw do
  devise_for :users
  root "documents#index"
  
  resources :documents, only: :show

  resources :learning_outcomes do
    resources :comments, only: :create  
  end

end
