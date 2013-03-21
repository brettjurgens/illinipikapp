# myapp.rb
require 'sinatra'
require 'haml'
require 'sass'

get '/' do
  haml :home, :locals => {}
end

get '/pages/:name' do |name|
  begin
    haml :page, :locals => {:page => name}
  rescue Errno::ENOENT
    haml :error
  end
end

get '/css/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"/app/css/#{params[:name]}")
end

set :public_folder, 'views/static'

get '/js/:name.js' do
  redirect 'js/:name.js'
end

get '/images/:name' do
  redirect 'images/:name'
end