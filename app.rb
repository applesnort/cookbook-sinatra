require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

require_relative 'cookbook'
require_relative 'recipe'
require_relative 'services/import/recipes_from_url'

use Rack::MethodOverride

set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file_path = File.join(__dir__,'recipes.csv')


get '/' do
  @cookbook = Cookbook.new(csv_file_path)
  @recipes = @cookbook.all
  erb :index
end

get '/new' do
  erb :create_form
end

get '/search' do
  @query = params[:query]
  @web_results = RecipesFromUrl.call(@query)
  erb :"search/results"
end

post '/recipes' do
  p params
  @cookbook = Cookbook.new(csv_file_path)
  @recipes = @cookbook.all
  recipe = Recipe.new(params)
  @cookbook.add_recipe(recipe)
  redirect to('/')
end

delete '/delete/:id' do
  p params
  @cookbook = Cookbook.new(csv_file_path)
  p @cookbook.all
  @cookbook.destroy(params[:id])
  p @cookbook.all
  redirect to('/')
end

get '/about' do
  erb :about
end
