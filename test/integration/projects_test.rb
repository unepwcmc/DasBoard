require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "/projects renders a list of projects by name" do
    project = {
      name: 'An project',
      objectives: []
    }.stringify_keys

    Couch::Db.
      expects(:get).
      with('_design/projects/_view/with_nested_objectives').
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

  test "/projects renders the list of objectives for each project" do
    project = {
      id: 'abc',
      name: 'An project',
      objectives: [{
        "_id" => '1',
        "name" => 'objective 1'
      },{
        "_id" => '2',
        "name" => 'objective 2'
      }]
    }.stringify_keys

    Couch::Db.
      expects(:get).
      with('_design/projects/_view/with_nested_objectives').
      returns({'rows' => [{
        "value" => project
      }]})

    get '/projects'

    assert_response :success

    assert_select "ul#projects" do
      assert_select "> li", {
        count: 1,
      }, 'Expected there only to be one project'
    end

    assert_select "ul#projects ul" do
      assert_select "li:first-child", { count: 1, text: "objective 1" }
      assert_select "li:last-child", { count: 1, text: "objective 2" }
    end
  end
end
