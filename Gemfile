source 'http://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.1.0'
gem 'rake', '0.8.7'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'uglifier'
end

group :production do
  gem 'rails_12factor'
end

gem 'jquery-rails'
gem 'paperclip'
gem 'formtastic'
gem 'kaminari'
gem 'aws-sdk', '~> 1.6'


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group 'development' do
  gem 'sqlite3'

  gem 'heroku'
  gem 'taps'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
