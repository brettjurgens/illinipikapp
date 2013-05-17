# app.rb
require 'sinatra'
require 'sass'
require 'haml'
require 'json'

# dev
require "sinatra/reloader" if development?

set :port, 1183

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
  # set up locals here, in case we have special pages (like donate)
  locals = {:page => name}
  if name.downcase == "donate"
    locals[:projects] = JSON.parse(File.read("projects.json"))
  end
  begin
    haml :page, :locals => locals
  rescue Errno::ENOENT
    haml :error, :locals => locals
  end
end

get '/ping' do
  return
end

get '/css/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"/app/css/#{params[:name]}", :style=>:compressed)
end

set :public_folder, 'views/static'