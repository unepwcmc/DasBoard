ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end

require 'mocha/test_unit'
