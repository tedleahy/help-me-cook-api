class AddInstructionsToRecipe < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :instructions, :text, array: true, after: :image_url
  end
end
