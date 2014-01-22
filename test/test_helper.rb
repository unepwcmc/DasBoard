ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"

class Minitest::Unit::TestCase
  def before_teardown
    CouchDb.delete_database
    CouchDb.create_database
    CouchDb.load_design_documents
  end
end

class ActiveSupport::TestCase
end
