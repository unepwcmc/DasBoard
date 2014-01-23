ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"

class ActiveSupport::TestCase
  def setup
    Couch::Db.delete_database
    Couch::Db.create_database
    Couch.load_design_documents
  end
end

require 'mocha/test_unit'
