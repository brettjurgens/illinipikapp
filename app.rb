# app.rb
require 'sinatra'
require 'stripe'
require 'sass'
require 'haml'

# Stripe
set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']
Stripe.api_key = settings.secret_key


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

# Stripe Methods...
post '/charge' do
  # amount comes in cents
  @amount = params[:amount]

  customer = Stripe::Customer.create(
    :email => params[:email],
    :card => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount => @amount,
    :description => "Donation",
    :currency => "usd",
    :customer => customer.id
  )
  haml :charge, :locals => {:charge => charge}
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