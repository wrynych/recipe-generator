require 'sinatra'
require 'securerandom'
require 'net/http'
require 'json'

api_key = ENV['UNIQUE_PASS_KEY']
random_org_api_url = 'https://api.random.org/json-rpc/2/invoke'

def generate_password(length, include_lower_case, include_upper_case, include_numbers, include_special_characters, api_key)
  request_payload = {
    jsonrpc: '2.0',
    method: 'generateIntegers',
    params: {
      apiKey: api_key,
      n: length,
      min: 33,  
      max: 126, 
      replacement: true,
      base: 10
    },
    id: 1
  }

  uri = URI(random_org_api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request.body = request_payload.to_json

  response = http.request(request)

  if response.is_a?(Net::HTTPSuccess)
    password = ''
    JSON.parse(response.body)['result']['random']['data'].each do |ascii_value|
      password += ascii_value.chr
    end
    password
  else
    'Failed to generate password'
  end
end

get '/' do
  erb :index
end

post '/generate' do
  @length = params[:length].to_i
  @include_lower_case = params[:lower_case] == 'on'
  @include_upper_case = params[:upper_case] == 'on'
  @include_numbers = params[:numbers] == 'on'
  @include_special_characters = params[:special] == 'on'

  if params[:basic]
    @include_lower_case = true
    @include_upper_case = true
    @include_numbers = true
    @include_special_characters = true
  end

  @password = generate_password(@length, @include_lower_case, @include_upper_case, @include_numbers, @include_special_characters, api_key)
  erb :result
end
