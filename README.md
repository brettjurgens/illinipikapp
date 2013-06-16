#illinipikapp

Website for Pi Kappa Phi Upsilon Chapter (Illinois)

## Technologies
    * [Sinatra (Ruby)](http://sinatrarb.com "Sinatra")
    * [Haml](http://haml.info/ "Haml")
    * [SCSS](http://sass-lang.com "SCSS")
    * [MongoDB](http://mongodb.org "MongoDB")
    * [Stripe](http://stripe.com "Stripe")
    * [Mandrill](http://mandrill.com "Mandrill")
    * [Heroku](http://heroku.com "Heroku")

## Heroku Addons
    * [MongoHQ](https://addons.heroku.com/mongohq)
    * [Mandrill](https://addons.heroku.com/mandrill)

## Some things

    head.haml
        * Doctype, HEAD, header, 'featured' image

    foot.haml
        * footer... copyright & social networking
      
    page.haml
        * Sets up the page content (i.e. heading, <section>)
        * grabs the relevant content from pagename.haml

    other haml files
        * info to be displayed on pages
        * routing is /pages/pagename, which will grab info from pagename.haml (/pagename also works)
        * only files that need to be edited to add content

    projects.json
        * Used to store the projects we're currently collecting donations for.
        * Should be stored in a database and not a JSON file
        * This is temporary...

    MongoDB
        * Used MongoDB to store user information
        * This was done simply because it was the easiest and cheapest
        * Feel free to use whatever...

## Extending it for your (chapter's) use

Feel free to reuse this for your own chapter (or personal use). If you make something better, submit a pull request.

## Bugs

If you find a bug, please report it. Thanks!

## Pull Requests

Wanna help? Awesome. Fork the repo and make a pull request.

## Running on Dev Server

Make a file called `config.rb` and with the contents:
    
    ```ruby
    ENV['STRIPE_PUBLISHABLE'] = 'pk_live_...'
    ENV['STRIPE_SECRET'] = 'sk_live_...'
    ENV['TEST_STRIPE_PUBLISHABLE'] = 'pk_test_...'
    ENV['TEST_STRIPE_SECRET'] = 'sk_test_...'
    ENV['MONGOHQ_URL'] = "mongodb://user:pass@mongohq..."
    ENV['MANDRILL_APIKEY'] = 'abc123...'
    ```

### Instructions:
    1. Fork the repo
    2. Modify
    3. git push heroku master

## Licensing

  Individual software packages will have their own licenses, you should check those as well, if you're interested.
  
    The MIT License (MIT)

    Copyright (c) 2013 Brett Jurgens

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.