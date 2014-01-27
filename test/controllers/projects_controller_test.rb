require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  test ':index assigns all projects' do
    Couch::Db.
      expects(:get).
      with('_design/projects/_view/all').
      returns({'rows' => [{
        "value" => {
          "name" => 'An project',
          "type" => "project",
          "objectives" => []
        }
      }]})

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
      with('_all_docs/?key=123').
      returns({'rows' => [{
        "id" => "123",
        "value" => {
          "name" => 'An project',
          "type" => "project",
          "objectives" => []
        }
      }]})

    get :show, id: '123'

    assert_response :success

    assigned_project = assigns(:project)
    assert_not_nil assigned_project, 'Expected @project to be assigned'
    assert_equal 'An project', assigned_project.first['value']['name']
  end

end
