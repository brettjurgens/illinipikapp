# app.rb
require 'sinatra'
require 'sass'
require 'haml'

# newrelic to fix heroku spindown
configure :production do
  require 'newrelic_rpm'
end

get '/' do
  begin
    haml :page, :locals => {:page => "welcome"}
  rescue Errno::ENOENT
    haml :error, :locals => {:page => "welcome"}
  end
end

get '/pages/:name' do |name|
  begin
    haml :page, :locals => {:page => name}
  rescue Errno::ENOENT
    haml :error, :locals => {:page => name}
  end
end

get '/ping' do
  return
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