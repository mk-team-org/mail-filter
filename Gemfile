
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.3'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'

gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'slim-rails'
gem 'simple_form'
gem 'bulk_insert'
gem 'devise'

group :development, :test do
  gem 'puma', '~> 3.0'
  gem 'pry-rails'
  gem 'pry-doc'
end

group :development do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rvm'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-unicorn-nginx', '~> 4.1.0'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'unicorn'
end
