require 'nokogiri'
require 'open-uri'

def main
  Recipe.destroy_all
  Ingredient.destroy_all

  urls = get_veggie_mob_urls
  urls.each_with_index do |url, _index|
    # TODO: handle ingredient groups
    next if %w[
      https://www.mobkitchen.co.uk/recipes/mushroom-cheese-tacos
      https://www.mobkitchen.co.uk/recipes/buffting-bruschetta-3-ways
      https://www.mobkitchen.co.uk/recipes/the-ultimate-homemade-falafel-pittas
    ].include?(url)

    recipe, ingredients = scrape_mob_kitchen(url)

    if recipe && ingredients
      puts Recipe.create_with_ingredients(recipe, ingredients) ? "Created #{recipe[:name]}" : "Error creating #{recipe[:name]}"
    else
      puts "Recipe name: #{recipe[:name]}"
      puts "ingredients: #{ingredients || nil}" if ingredients.nil?
    end

    puts "\n--------------------\n\n"
  end
end

def get_veggie_mob_urls(url = 'https://www.mobkitchen.co.uk/?category=Veggie%20Mob')
  doc = Nokogiri::HTML(open(url, 'User-Agent' => 'Nooby'))

  recipe_anchors = doc.search('a.Blog-header-content-link')
  urls = recipe_anchors.map { |a| 'https://www.mobkitchen.co.uk' + a.attributes['href'].value }

  last_article_offset = recipe_anchors.last.parent.parent.parent.attributes['data-offset'].value

  if last_article_offset == '1494681600457' # this is the offset of the first recipe, so there's no more URLs to get after here
    urls
  else
    more_recipes_url = "https://www.mobkitchen.co.uk/?category=Veggie%20Mob&offset=#{last_article_offset}&format=main-content"
    urls + get_veggie_mob_urls(more_recipes_url)
  end
end

def scrape_mob_kitchen(url)
  puts "Scraping URL: #{url}"

  doc = Nokogiri::HTML(open(url, 'User-Agent' => 'Nooby'))

  ingredients = get_list_after_heading(doc, 'Ingredients')
  old_ingredients = ingredients

  ingredients = ingredients.map { |ingredient_str| Ingredient.parse(ingredient_str) }
                           .reject { |ingredient| ingredient[:name].downcase.include?('total cost') }

  old_ingredients.each_with_index { |x, i| puts "#{x} -> #{ingredients[i]}" }

  recipe = {
    name: doc.at('h1.Blog-title').children.text,
    source_url: url,
    instructions: get_list_after_heading(doc, 'Method')
  }

  [recipe, ingredients]
end

def get_list_after_heading(doc, heading)
  heading_node = doc.at("h2:contains('#{heading}')") ||
                 doc.at("h3:contains('#{heading}')") ||
                 doc.at("h3:contains('#{heading.upcase}')")
  heading_node.next_element.children.map(&:text)
end

main
