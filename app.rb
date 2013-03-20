# myapp.rb
require 'sinatra'
require 'haml'
require 'sass'

get '/' do
  haml :list, :locals => {}
end

get '/css/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"/app/css/#{params[:name]}")
end

set :public_folder, 'views/static'

get '/js/:name.js' do
  redirect 'js/:name.js'
end