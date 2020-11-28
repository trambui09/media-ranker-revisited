Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "works#root"
  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"
  get '/auth/github', as: 'github_login'
  get '/auth/:provider/callback', to: 'users#create', as: 'auth_callback'
  post "/logout", to: "users#logout", as: "logout"

  resources :works
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"

  resources :users, only: [:index, :show]
end
