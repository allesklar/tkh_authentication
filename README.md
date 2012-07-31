# TKH Authentication

This is a Rails engine which provides basic authentication. It is based on Railscasts 250 and 274.

Primarily developed for Ten Thousand Hours but we are happy to share if anybody finds it useful.

It's still in its infancy. Many improvements to come.

## Installation

Add this line to your application's Gemfile:

    gem 'tkh_authentication', '~> 0.0'

And then execute:

    $ bundle

Import migration and locale files

		$ rails g tkh_authentication:install
		
Run the migration

		$ rake db:migrate
		
You need a root route in your app but most apps have that already.

And then of course restart your server!

		$ rails s
		
Upon upgrading to a new version of the gem you might have to update the translation files

		$ rails g tkh_authentication:update_locales -f


## Usage


A starting point could be:

    $ /login

... and it should work out of the box.

To display the login information module anywhere in your views

		render 'shared/login_info'
		
At this point the user only needs to be authenticated to access any area. We are coming up with an authorization solution as well. To restrict access to your controllers:

		before_filter :authenticate
		
If you want to restrict access to users whose admin boolean attribute is true

		before_filter :authenticate_with_admin


## Contributing

Pull requests for new features and bug fixes are welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create your failing tests based on the Test Unit framework.
4. Create your code which makes the tests pass.
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
