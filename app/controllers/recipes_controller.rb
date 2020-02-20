class RecipesController < ApplicationController
  def create
    recipe = recipe_params.slice(:name, :image_url)
    ingredients = params[:ingredients]

    if Recipe.create_with_ingredients(recipe, ingredients)
      render json: { message: "New recipe #{recipe[:name]} successfully created" }
    else
      render json: { message: 'Error creating recipe' }
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :image_url)
  end
end
