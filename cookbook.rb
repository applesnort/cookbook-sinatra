require_relative 'app.rb'
require 'csv'
require 'pry'

class Cookbook
  def initialize(csv_file_path)
    @recipes = []
    @csv_file_path = csv_file_path
    @next_id = 1
    import_csv if File.exist?(@csv_file_path)
  end

  attr_reader :recipes

  def all
    return @recipes
  end

  def add_recipe(new_recipe)
    new_recipe.id = @next_id
    @recipes << new_recipe
    @next_id += 1
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

  def destroy(id)
    @recipes = @recipes.each.reject { |item| item.id == id.to_i }
    store_in_csv
  end

  private

  def import_csv
    CSV.foreach(@csv_file_path, headers: :first_row, header_converters: :symbol) do |row|
      row[:id] = row[:id].to_i
      row[:name] = row[:name]
      row[:description] = row[:description]
      row[:prep_time] = row[:prep_time]
      row[:difficulty] = row[:difficulty]
      row[:done] = row[:done]
      row[:img] = row[:img]
      @recipes << Recipe.new(row)
    end
    @next_id = @recipes.last.id + 1 unless @recipes.empty?
  end

  def store_in_csv
    # column_header = ["id", "name", "description", "prep time", "difficulty", "done", "img"]
    # csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_file_path, 'wb') do |csv|
      csv << %w[id name description prep_time difficulty done img]
      @recipes.each do |recipe|
        # write one row contianing a recipe object
        p "HELLO FROM: store_in_csv #{recipe}"
        csv << [
        recipe.id,
        recipe.name, 
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
