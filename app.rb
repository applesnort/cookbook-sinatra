require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"

require_relative 'cookbook'
require_relative 'recipe'

set :bind, '0.0.0.0'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file_path = 'recipes.csv'


get '/' do
  @cookbook = Cookbook.new(csv_file_path)
  @recipes = @cookbook.all
  erb :index
end

get '/new' do
  erb :create_form
end

post '/recipes' do
  @cookbook = Cookbook.new(csv_file_path)
  @recipes = @cookbook.all
  p params
  recipe = Recipe.new(params)
  p recipe
  @cookbook.add_recipe(recipe)
  redirect to('/')
end

post '/destroy' do
  @cookbook = Cookbook.new(csv_file_path)
  @recipes = @cookbook.all
  # select recipe.id?
  # send recipe.id to @cookbook.remove_recipe(recipe)
  redirect to('/')
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
