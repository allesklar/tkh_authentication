# TKH Authentication



## 0.1.1

* Translated the logout link in sidebar and removed button class


## 0.1

* Styled login form the simple_form way
* Changed some text and translations in login form
* Worked on text and translation in signup form 
* The shared/menus partial is called from all authentication pages


## 0.0.12

* Added an administrator? method
* Refactored the authenicate_as_admin method


## 0.0.11

* Modified some German translation strings.


## 0.0.10

* Added the German translation strings.


## 0.0.9

* Administrator can enable other users do become admins or remove their privileges
* localized a few users index view strings
* Refactored migrations generator
* Added an update rake task


## 0.0.8

* User has_many pages
* Cleaned up locale files
* Added German locale but translated strings are not in yet


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
