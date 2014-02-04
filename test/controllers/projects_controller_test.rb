require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  test ':index assigns all projects' do
    Project.
      expects(:view).
      with(:all).
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

  test ':show assigns the project with nested metrics' do
    project_json = {
      "_id" => "123",
      "name" => 'An project',
      "type" => "project",
      "objectives" => []
    }
    Project.expects(:find_with_nested_objectives).
      with('123').
      returns([{
        "value" => project_json
      }])

    Project.expects(:populate_metrics_on_objectives!).
      with(project_json)

    get :show, id: '123'

    assert_response :success

    assigned_project = assigns(:project)
    assert_not_nil assigned_project, 'Expected @project to be assigned'
    assert_equal 'An project', assigned_project['name']
  end

end
