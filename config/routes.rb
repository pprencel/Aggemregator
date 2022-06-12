Rails.application.routes.draw do
  root to: "projects#index" # tempomary walk around
  resources :jewels  do
    get :autocomplete, on: :collection
  end
  resources :projects
  get 'home/index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
