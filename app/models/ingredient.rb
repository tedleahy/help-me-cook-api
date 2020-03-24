class Ingredient < ApplicationRecord
  has_many :ingredient_recipes, dependent: false
  has_many :recipes, through: :ingredient_recipes

  validates :name, presence: true, uniqueness: true
end
