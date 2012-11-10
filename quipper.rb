require 'yaml'

prefs = YAML.load_file(File.expand_path('~/.quipper'))

run "rm public/index.html"

file 'config/mongo.yml', <<-CODE
defaults: &defaults
  host: 127.0.0.1
  port: 27017

development:
  <<: *defaults
  database: quipper_web_development

test:
  <<: *defaults
  database: quipper_web_test

edge:
  uri: <%= ENV['MONGOLAB_URI'] %>

production:
  uri: <%= ENV['MONGOLAB_URI'] %>
CODE

initializer 'schema.rb', <<-CODE
require_dependency 'schema/seed/all'
CODE

gem 'schema', git: "https://#{prefs['github_user']}@github.com/quipper/schema.git"

gem_group :development, :test do
  gem "rspec-rails"
end

run "bundle install"

generate('rspec:install')

inject_into_file 'spec/spec_helper.rb', after: 'require File.expand_path("../../config/environment", __FILE__)' do
  "\nrequire 'factory_girl_rails'"
end

file 'spec/factories.rb', <<-CODE
require 'schema/factories/seed'
CODE
