require 'test_helper'

class ObjectivesTest < ActionDispatch::IntegrationTest
  test "/show renders the title of the objective" do
    objective = {
      _id: '5',
      name: 'An objective'
    }.stringify_keys

    Couch::Db.
      expects(:get).
      with("/#{objective['_id']}").
      returns(
        objective
      )

    get "/objectives/#{objective['_id']}"

    assert_response :success
    assert_select 'h1', objective['name']
  end
end
