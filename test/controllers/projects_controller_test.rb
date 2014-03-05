require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  test ':index assigns all projects' do
    projects = [Project.new({id: '123', name: 'An project'})]
    Project.
      expects(:all).
      returns(projects)

    get :index

    assert_response :success

    assigned_projects = assigns(:projects)
    assert_not_nil assigned_projects, 'Expected @projects to be assigned'
    assert_equal 1, assigned_projects.length
    assert_equal 'An project', assigned_projects.first.name
  end

  test ':show assigns the project with nested metrics' do
    project_id = '123'
    Project.expects(:find)
      .with(project_id)
      .returns(Project.new({
        id: project_id,
        name: "An project"
      }))

    get :show, id: project_id

    assert_response :success

    assigned_project = assigns(:project)
    assert_not_nil assigned_project, 'Expected @project to be assigned'
    assert_equal 'An project', assigned_project.name
  end

  test ':show assigns a list of metrics' do
    project_id = '123'
    Project.expects(:find).
      with(project_id).
      returns(Project.new(id: project_id))

    metrics = [Metric.new({name: "Fancy banana"})]

    Metric.expects(:all)
      .returns(metrics)

    get :show, id: project_id

    assigned_metrics = assigns(:metrics)
    assert_not_nil assigned_metrics, "Expected @metrics to be assigned"

    assert_equal 1, assigned_metrics.length
    assert_equal assigned_metrics.first, metrics.first
  end

  test "PUT /project/:id updates the project" do
    project = Project.create(name: "a crappy name")

    put :update, id: project.id, project: { name: "a much better name" }

    updated_project = Project.find(project.id)

    assert_equal "a much better name", updated_project.name
  end

  test "GET /projects/new creates a new project in the database" do
    assert_difference('Project.count', 1) do
      get :new
    end

    assert_equal "Enter the name of the new project", assigns(:project).name
    assert_response :redirect
  end
end
