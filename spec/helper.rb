# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require 'rspec'
require 'factory_girl'
require 'database_cleaner'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

RSpec.configure do |config|
	require 'rspec/expectations'
  config.include RSpec::Matchers
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end