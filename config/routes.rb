Rails.application.routes.draw do
  post '/recipes/create', to: 'recipes#create'
  get '/recipes', to: 'recipes#index'
  get '/recipes/:id', to: 'recipes#show'
  get '/recipes_with_ingredients', to: 'recipes#index_with_ingredients'
end
