Rails.application.routes.draw do
  devise_for :users
  root "documents#index"
  
  resources :documents, only: :show

  resources :learning_outcomes do
    resources :comments, only: :create
    collection do
      get 'history'
    end
  end

  resources :study_guides, only: :index

end
