source 'https://rubygems.org'
ruby '2.6.2'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.2.1'
gem 'pg', '0.21'
gem 'puma', '~> 5.5', group: [:development, :production]
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder'
gem 'redis'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap', '~> 4.3.1'
gem 'font-awesome-sass', '~> 5.0.13'
gem 'momentjs-rails', '>= 2.9.0'
gem 'moment_timezone-rails'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-timepicker-rails', :path => 'vendor/gems/bootstrap-timepicker-rails'
gem 'pg_search'
gem 'kaminari'
gem 'devise'
gem 'simple_form'
gem 'select2-rails'
gem 'pundit'
gem 'prawn'
gem 'prawn-table'
gem 'prawn-icon'
gem 'prawn-print'
gem 'axlsx', '2.1.0.pre'
gem 'axlsx_rails'
gem 'roo', "~> 2.7.0"
gem 'roo-xls'
gem "spreadsheet"
gem 'public_activity'
gem 'mina-puma', require: false
gem 'delayed_job_active_record'
gem 'mini_magick'
gem 'chronic'
gem "responders"
gem 'bootsnap', require: false
gem 'rack-mini-profiler', require: false
gem 'memory_profiler'
gem 'whenever', :require => false
gem "simple_calendar"
gem 'traceroute'
gem 'chosen-rails'
gem 'timepiece'

group :development, :test do
  gem 'rspec-rails', '~> 3.8.0'
  gem 'rubocop', require: false
  gem 'rubocop-rspec'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
  gem 'bullet'
  gem 'pry-rails'
end

group :test do
  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'rails-controller-testing'
  gem 'database_rewinder'
  gem 'pdf-inspector', require: "pdf/inspector"
end


