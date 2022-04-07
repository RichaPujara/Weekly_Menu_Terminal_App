require 'rubygems'
require 'mechanize'
require 'json'
require 'oj'

def all_recipes(url)
    agent = Mechanize.new
    page = agent.get(url)
    recipes = page.search('article.post-summary.primary h2.post-summary__title a')
    recipe_list = []
    recipes.each do |recipe|
        individual_recipe = {}
        individual_recipe[:title] = recipe.text
        individual_recipe[:link] = recipe['href']
        recipe_list.push(individual_recipe)
    end
    File.open('recipe_list.json', 'a') { |f| f << recipe_list.to_json }
    link = page.link_with(text: 'Go to Next Page')
    return recipe_list.length if link.nil?

    page = link.click
    all_recipes(page.uri)
end
puts all_recipes('https://www.vegrecipesofindia.com/recipes/indian-breakfast-recipes/')


