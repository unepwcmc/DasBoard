require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  test ':index assigns all projects' do
    Project.
      expects(:all).
      returns([{
        "value" => {
          "_id" => 'anid',
          "name" => 'An project',
          "type" => "project",
        }
      }])

    get :index

    assert_response :success

    assigned_projects = assigns(:projects)
    assert_not_nil assigned_projects, 'Expected @projects to be assigned'
    assert_equal 1, assigned_projects.length
    assert_equal 'An project', assigned_projects.first['value']['name']
  end

  test ':show assigns the project' do
    Couch::Db.
      expects(:get).
      with('_design/projects/_view/with_nested_objectives?startkey=["123", null]&endkey=["123", {}]').
      returns({"rows" => [{
        "value" => {
          "_id" => "123",
          "name" => 'An project',
          "type" => "project",
          "objectives" => []
        }
      }]})

    get :show, id: '123'

    assert_response :success

    assigned_project = assigns(:project)
    assert_not_nil assigned_project, 'Expected @project to be assigned'
    assert_equal 'An project', assigned_project['name']
  end

end
