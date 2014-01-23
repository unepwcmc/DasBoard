require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "/projects renders a list of projects by name" do
    project = {
      name: 'An project',
      type: "project"
    }.stringify_keys

    Couch::Db.
      expects(:get).
      with('_designs/projects/_views/all').
      returns({'rows' => [project]})

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
