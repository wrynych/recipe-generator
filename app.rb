require "sinatra"
require "sinatra/reloader"
require 'securerandom'

# Генерируем случайный пароль
def generate_password(length, include_lower_case, include_upper_case, include_numbers, include_special_characters)
  characters = []
  characters += ('a'..'z').to_a if include_lower_case
  characters += ('A'..'Z').to_a if include_upper_case
  characters += (0..9).to_a if include_numbers
  characters += %w(! @ # $ % ^ & *) if include_special_characters

  password = ''
  length.times { password += characters.sample.to_s }
  password
end

get '/' do
  erb :index
end

post '/generate' do
  length = params[:length].to_i
  include_lower_case = params[:lower_case] == 'on'
  include_upper_case = params[:upper_case] == 'on'
  include_numbers = params[:numbers] == 'on'
  include_special_characters = params[:special] == 'on'

  @password = generate_password(length, include_lower_case, include_upper_case, include_numbers, include_special_characters)
  erb :result
end
