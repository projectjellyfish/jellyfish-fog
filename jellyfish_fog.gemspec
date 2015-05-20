$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_fog/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-fog'
  s.version     = Jellyfish::Fog::VERSION
  s.authors     = ['mafernando']
  s.email       = ['fernando_michael@bah.com']
  s.homepage    = 'http://www.projectjellyfish.org/'
  s.summary     = 'Jellyfish Fog Module '
  s.description = 'A module that adds Fog support to Jellyfish API'
  s.license     = 'APACHE'
  s.files       = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.add_dependency 'rails'
  s.add_dependency 'dotenv-rails' # to use env vars from jellyfish api
  s.add_dependency 'pg' # to use jellyfish db
  s.add_dependency 'azure', '>= 0.6.0'
  s.add_dependency 'fog'
  s.add_dependency 'fog-azure'
  s.add_dependency 'bcrypt'
end
