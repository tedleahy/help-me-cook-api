class AddAttributesToRecipe < ActiveRecord::Migration[6.0]
  def change
    change_table :recipes, bulk: true do |_t|
      t.servings :integer
      t.source_url :text
      t.prep_time_mins :integer
      t.cook_time_mins :integer
      t.total_time_mins :integer
    end
  end
end
