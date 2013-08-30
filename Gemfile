source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.12'

group :production do
	gem 'newrelic_rpm'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development do
	gem 'better_errors'
	gem "binding_of_caller"
end

# gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'synergy', :git => 'git://github.com/secoint/synergy.git', :branch => '1-3-x'
gem 'spree_auth_devise', :git => 'git://github.com/spree/spree_auth_devise', :branch => '1-3-stable'
gem 'spree_i18n', :git => 'git://github.com/secoint/spree_i18n.git', :branch => '1-3-stable'
gem 'spree_static_content', :git => 'git://github.com/spree/spree_static_content.git', :branch => '1-3-stable'
gem 'spree_editor', :git => 'git://github.com/secoint/spree_editor.git'
gem 'spree_online_support', :git => 'git://github.com/secoint/spree_online_support.git'
gem 'spree_address_book', :git => 'git://github.com/romul/spree_address_book.git'

gem 'nokogiri-happymapper'
gem 'aws-sdk'