Rails.application.routes.draw do
  post '/recipes/create', to: 'recipes#create'
end
