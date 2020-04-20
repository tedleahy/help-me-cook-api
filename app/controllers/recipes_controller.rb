class RecipesController < ApplicationController
  def create
    recipe = recipe_params.except(:ingredients)
    ingredients = recipe_params[:ingredients]

    created_recipe = Recipe.create_with_ingredients(recipe, ingredients)

    if created_recipe
      render json: RecipeSerializer.new(created_recipe[:recipe])
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

  def show_with_ingredients
    render json: RecipeSerializer.new(Recipe.find(params[:id]))
  end

  def search_by_ingredients
    recipes = Recipe.all.select do |recipe|
      # select where the recipe ingredients contain all ingredients from params[:ingredient_names]
      (recipe.ingredients.map(&:name) - params[:ingredient_names]).empty?
    end

    render json: RecipeSerializer.new(recipes)
  end

  private

  def recipe_params
    load_params = params.require(:recipe).permit(:name, :image_url, :servings, :source_url,
                                                 :prep_time_mins, :cook_time_mins, :total_time_mins, instructions: [])
    load_params[:ingredients] = params[:ingredients]
    load_params.permit!
  end
end
