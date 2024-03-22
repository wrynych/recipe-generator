require 'sinatra'
require 'sinatra/reloader' if development?
require 'httparty'
require 'json'

# Load API key from environment variables or GitHub secrets
RECIPE_API_KEY = ENV['RECIPE_KEY']

# Set up the root route
get '/' do
  erb :index
end

post '/search' do
  # Get form inputs (code omitted for brevity)
  
  # Make a request to the Spoonacular API to search for recipes
  response = HTTParty.get("https://api.spoonacular.com/recipes/complexSearch", query: query_params)
  
  # Debug: Output the response to console
  puts response.inspect
  
  # Parse the JSON response
  data = JSON.parse(response.body)
  
  # Debug: Output the parsed JSON data to console
  puts data.inspect
  
  # Extract relevant information from the response
  if data['results']
    @recipes = data['results']
    erb :results  # Render the results template
  else
    @error = data['message']
    erb :error  # Render an error template
  end
end
