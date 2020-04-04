# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

def main
  Recipe.destroy_all
  Ingredient.destroy_all

  urls = get_veggie_mob_urls
  urls.each do |url|
    # next unless url == 'https://www.mobkitchen.co.uk/recipes/ginger-basil-noodles'

    recipe, ingredients = scrape_mob_kitchen(url)

    if recipe && ingredients
      puts Recipe.create_with_ingredients(recipe, ingredients) ? "Created #{recipe[:name]}" : "Error creating #{recipe[:name]}"
    else
      puts "Recipe name: #{recipe[:name]}"
      puts "ingredients: #{ingredients || nil}" if ingredients.nil?
    end
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
  ingredients = process_ingredients(ingredients)

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

def process_ingredients(ingredients)
  return nil unless ingredients

  ingredient_units = %w[ml l g tbsp tsp]
  ingredient_units_regex = "(#{ingredient_units.join('|')})"
  ingredient_with_unit_regex = Regexp.new('(\d+)\s*' + ingredient_units_regex + '\s[of\s]*(\D+)', Regexp::IGNORECASE)

  whole_ingredient_regex = /(\d+)\s(.+)/

  ingredients.map do |ingredient|
    next if not_ingredient(ingredient)

    name, amount, amount_unit = nil

    if ingredient.match(ingredient_with_unit_regex) # e.g. '3 tsp sugar', '100g flour', '50ml water'
      amount, amount_unit, name = ingredient.scan(ingredient_with_unit_regex).first

      if amount_unit.downcase == 'l'
        amount = amount.to_f * 1000
        amount_unit = 'ml'
      end

    elsif ingredient.match(whole_ingredient_regex) # e.g. '4 Aubergines', '2 Carrots'
      amount, name = ingredient.scan(whole_ingredient_regex).first
      amount_unit = 'whole'

    else # no amount or unit, e.g. 'Salt', 'Pepper', 'Oil'
      name = ingredient
    end

    { name: filter_ingredient_name(name), amount: amount.to_f, amount_unit: amount_unit&.downcase }
  end
end

def filter_ingredient_name(name)
  trailing_characters = %w[: - ( )]
  trailing_characters_regex = "[#{trailing_characters.join('|')}]$j"

  name.downcase
      .sub(/\s*-*\s*£.*\s*/, '')
      .sub(/[[:space:]]*$/, '') # remove ALL trailing spaces, not just ASCII ones
      .sub('- included in mob kitchen ingredients.', '')
      .sub(trailing_characters_regex, '')
end

def not_ingredient(ingredient)
  ingredient.match(/- this covers absolutely.*/) ||
    ingredient.match(/for the .*:*$/)

  # [
  # '- this covers absolutely everything.',
  # '- this covers absolutely everything. all we assume you have in your kitchen beforehand is salt, pepper and olive oil.'
  # ].include?(ingredient)
end

main
