$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_fog/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish_fog'
  s.version     = JellyfishFog::VERSION
  s.authors     = ['mafernando']
  s.email       = ['fernando_michael@bah.com']
  s.homepage    = 'www.projectjellyfish.org'
  s.summary     = 'Jellyfish Fog Module '
  s.description = 'A module that adds fog support to Jellyfish API'
  s.license     = 'APACHE'
  s.files       = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.add_dependency 'rails'
  s.add_dependency 'dotenv-rails' # to use env vars from jellyfish api
  s.add_dependency 'pg' # to use jellyfish db
end
