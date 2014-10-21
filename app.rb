# app.rb
require 'sinatra'
require 'sass'
require 'haml'
# require 'json'
require 'stripe'
require 'mongo'
require 'uri'
require 'mandrill'

# get some (stripe)
# require File.join(File.dirname(__FILE__), 'config') if development?
set :publishable_key, ENV['STRIPE_PUBLISHABLE']
set :secret_key, ENV['STRIPE_SECRET']
Stripe.api_key = settings.secret_key

# dev
require "sinatra/reloader" if development?

set :port, 1183 if development?

# newrelic to fix heroku spindown
configure :production do
  require 'newrelic_rpm'
end

# mongo
def get_connection
  return @db_connection if @db_connection
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
end

get '/' do
  begin
    haml :page, :locals => {:page => "welcome"}
  rescue Errno::ENOENT
    haml :error, :locals => {:page => "welcome"}
  end
end

get '/ping' do
  return
end

# wutup, stripe?
post '/neworder' do
  name = params[:name]
  desc = params[:desc]
  id = params[:id]

  haml :neworder, :locals => { :stripe_pk => settings.publishable_key, :name => name, :desc => desc, :id => id }
end

post '/charge' do
  email = params[:email] || "test@mctest.in"
  amount = params[:amount]
  print_amount = params[:print_amount]
  name = params[:name]
  desc = params[:desc]
  id = params[:id]

  # connect to the mongo
  db = get_connection

  # lookup customer
  coll = db["users"]
  res = coll.find_one("email" => email)

  # for error handling...?
  continue = true
  # and then...
  if res != nil
    customer = Stripe::Customer.retrieve({ :id => res['id'] })
    customer.card = params[:stripeToken]
    begin
      customer.save
    rescue
      haml :ordererror, :locals => { "error" => "Card error."}
      continue = false
    end
  else
    begin
      customer = Stripe::Customer.create(
        :email => email,
        :card => params[:stripeToken]
      )
      new_cust = { "id" => customer.id, "email" => email }
      coll.insert(new_cust)
    rescue
      print "shit shit shit.\n"
      continue = false
    end
  end
  if(continue)
    begin
      charge = Stripe::Charge.create(
        :amount => amount,
        :description => name,
        :currency => 'usd',
        :customer => customer.id
      )
    rescue
      print "fuck something fucked up.\n"
      continue = false
    end
    if(continue)
      begin
        # send an email confirmation...
        m = Mandrill::API.new # All official Mandrill API clients will automatically pull your API key from the environment

        print_amount = '%.2f' % print_amount
        donateamt = print_amount.to_f*0.971 - 0.3
        donateamt = '%.2f' % donateamt

        render = m.templates.render 'receipt', [
            {
              :name => "name",
              :content => name
            },
            {
              :name => "desc",
              :content => desc
            },
            {
              :name => "total",
              :content => "$#{print_amount}"
            },
            {
              :name => "donate-total",
              :content => "$#{donateamt}"
            }
          ]

        message = {
          :subject => "Thank you for your donation!",
          :from_name => "Pi Kappa Phi Upsilon Chapter",
          :text => "Thank you for your donation of #{amount} and your help in funding #{name}.",
          :to => [
            {
              :email => email,
              :name => email
            }
          ],
          :html => render['html'],
          :from_email => "no-reply@illinipikapp.com"
        }

        send = m.messages.send message
      rescue 
        print "Email could not be sent"
      end
    else
      haml :ordererror, :locals => { "error" => "Error charging your card, please go back and try again."}
    end # end continue if

    begin
      haml :charged, :locals => { :amount => print_amount, :email => email, :name => name, :desc => desc }
    rescue
      haml :ordererror, :locals => {"error" => "An error occured while processing your donation. Please contact pkpupsilon@gmail.com for more information."}
    end
  else
    haml :ordererror, :locals => { "error" => "Error charging your card, please go back and try again."}
  end # end continue if
end

get '/testmongo' do
  db = get_connection
  puts db.collection_names
end

get '/events/:name' do |name|
  locals = {:page=>name}
  begin
    haml :event, :locals => locals
  rescue Errno::ENOENT
    haml :error, :locals => locals
  end
end

['/:name/?', '/pages/:name/?'].each do |path|
  get path do |name|
    # set up locals here, in case we have special pages (like donate)
    locals = {:page => name}
    if name.downcase == "donate"
      # move this to its own service later on (with a sick RESTful API)
      locals[:projects] = JSON.parse(File.read("projects.json"))
    end
    begin
      haml :page, :locals => locals
    rescue Errno::ENOENT
      haml :error, :locals => locals
    end
  end
end


get '/css/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"/app/css/#{params[:name]}", :style=>:compressed)
end

set :public_folder, 'views/static'