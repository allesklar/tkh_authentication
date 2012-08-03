# TKH Authentication



## 0.0.7

* Safe redirect to root if host app did not set up the root route


## 0.0.6

* Redirect users to target page upon logging in if they had been interrupted by authenticate or authenticate_with_admin filters


## 0.0.5

* Users controller has both an authenticate and an authenticate_with_admin before_filters


## 0.0.4

* Added an install rake task to run the migration and locale generators
* Refactored generators to give them more flexibility


## 0.0.3

* Added an authenticate_as_admin controller method and its translations
* Added a generator to update tkh_authentication locales in the host app


## 0.0.2

* Populated all Spanish translations


## 0.0.1

* Initial release
