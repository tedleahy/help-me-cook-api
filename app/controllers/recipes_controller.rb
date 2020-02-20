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

  def index
    render json: Recipe.all
  end

  def index_with_ingredients
    render json: RecipeSerializer.new(Recipe.all)
  end

  def show
    render json: Recipe.find(params[:id])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :image_url)
  end
end
