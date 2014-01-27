require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "/projects renders a list of projects by name" do
    project = {
      name: 'An project',
      objectives: []
    }.stringify_keys

    Couch::Db.
      expects(:get).
      with('_design/projects/_view/all').
      returns({'rows' => [{
        "value" => project
      }]})

    get '/projects'

    assert_response :success

    assert_select "ul#projects" do
      assert_select "li", {
        count: 1,
        text: project['name']
      }, 'Expected to see project name'
    end
  end
end
