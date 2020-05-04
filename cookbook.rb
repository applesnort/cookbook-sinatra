require_relative 'app.rb'
require 'csv'
require 'pry'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    import_csv
  end

  attr_reader :recipes

  def all
    return @recipes
  end

  def add_recipe(new_recipe)
    @recipes << new_recipe
    store_in_csv
  end
  
  def mark_as_done(index)
    @recipes[index].mark_as_done!
    store_in_csv
  end

  def find_recipe(recipe_index)
    recipe.remove_recipe!
    return recipe
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    store_in_csv
  end

  private

  def import_csv
    CSV.foreach(@csv_file_path, headers: :first_row) do |row|
      @recipes << Recipe.new(row)
    end
  end

  def store_in_csv
    column_header = ["name", "description", "prep time", "difficulty", "done", "image"]
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_file_path, 'wb', csv_options) do |csv|
      csv << column_header
      @recipes.each do |recipe|
        # write one row contianing a recipe object
        csv << [recipe.name, 
        recipe.description, 
        recipe.prep_time, 
        recipe.difficulty, 
        recipe.done?,
        recipe.img
      ]
      end
    end
  end
end
