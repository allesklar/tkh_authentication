$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tkh_authentication/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tkh_authentication"
  s.version     = TkhAuthentication::VERSION
  s.authors     = ["Swami Atma"]
  s.email       = ["swami@TenThousandHours.eu"]
  s.homepage    = "http://tenthousandhours.eu"
  s.summary     = "Simple authentication Rails engine."
  s.description = "A Rails engine for access control authentication customized for Ten Thousand Hours."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md", "CHANGELOG.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency 'bcrypt-ruby', '~> 3.0'
  s.add_dependency 'simple_form', '~> 2.0'
  s.add_dependency 'stringex'

  s.add_development_dependency "sqlite3"
end
