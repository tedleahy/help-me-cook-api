Rails.application.routes.draw do
  post '/recipes/create', to: 'recipes#create'
  get '/recipes', to: 'recipes#index'
end
