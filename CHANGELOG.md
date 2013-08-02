# TKH Authentication


## 0.1.8

* Added other name attribute to user model
* Integrated views and functionality with the new tkh-mailing-list gem. tkh-authentication handles the user model and creation of records by user and tkh-mailing-list will handle all additions/modifications/deletions by the admin.


## 0.1.7

* Added administrators scope to user model


## 0.1.6

* Added a formal_name virtual attribute to the user model
* Added the alphabetically scope to the user model


## 0.1.5

* Modified the login info in sidebar partial
* Added a login info for navbar partial


## 0.1.4

* Set up all missing translations
* Improved and debugged user mailer


## 0.1.3

* Added login module partial to embed in pages and set it up with bootstrap tabs
* Refactored login and signup forms
* A logged-in user cannot got to login or signup page. They are redirected to the root page.
* The two reset password views have now headings and one explanation. More friendly and it makes it clear that it can be used to change one's password even without having forgotten it.


## 0.1.2

* Minor translation fix


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
