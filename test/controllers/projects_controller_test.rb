require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  def test_the_index_assigns_all_projects
    Couch::Db.
      expects(:get).
      with('_designs/projects/_views/all').
      returns({'rows' => [{
        name: 'An project',
        type: "project"
      }]})

    get :index

    assert_response :success

    assigned_projects = assigns(:projects)
    assert_not_nil assigned_projects, 'Expected @projects to be assigned'
    assert_equal 1, assigned_projects.length
    assert_equal 'An project', assigned_projects.first[:name]
  end

end
