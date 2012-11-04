require 'yaml'

prefs = YAML.load_file(File.expand_path('~/.quipper'))

run "rm public/index.html"

initializer 'mongo.rb', <<-CODE
db_test = '#{prefs['database']['test']}'
db_development = '#{prefs['database']['development']}'

path = if Rails.env.production?
  ENV['MONGOLAB_URI']
else 
  "mongodb://@localhost:27017/" << (Rails.env.test? ? db_test : db_development)
end

MongoMapper.config = { Rails.env => { 'uri' => path } }
MongoMapper.connect(Rails.env)
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

file 'spec/factories.rb', <<-CODE
require 'schema/factories/seed'
CODE
