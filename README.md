# TKH Authentication

This is a Rails engine which provides an app with basic authentication. It is based on Railscasts 250 and 274.

Primarily developed for Ten Thousand Hours but we are happy to share if anybody finds it useful.

It's still in its infancy. Many improvements to come.

## Installation

Add this line to your application's Gemfile:

    gem 'tkh_authentication', '~> 0.0'

And then execute:

    $ bundle

Create a migration for user model with the following attributes:

		$ def change
		  create_table :users do |t|
		    t.string :email
		    t.string :password_digest
		    t.string :first_name
		    t.string :last_name
		    t.boolean :admin, default: false
		    t.string  :auth_token
		    t.string  :password_reset_token
		    t.datetime  :password_reset_sent_at

		    t.timestamps
		  end
		end
		
Run the migration

		$ rake db:migrate
		
You need a root route in your app but most apps have that already.

And then of course restart your server!


## Usage


A starting point could be:

    $ /login

... and it should work out of the box.


## Contributing

Pull requests for new features and bug fixes are welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create your failing tests based on the Test Unit framework.
4. Create your code which makes the tests pass.
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
