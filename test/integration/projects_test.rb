require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest

  test "/projects renders a list of projects links by name" do
    project_id = '123abc'
    project = {
      name: 'An project',
      type: 'project'
    }.stringify_keys

    Couch::Db.put("/#{project_id}", project)

    get '/projects'

    assert_response :success

    assert_select "ul#projects" do
      assert_select "li", {
        count: 1,
        text: project['name']
      }, 'Expected to see project name'

      assert_select "a" do
        assert_select "[href=?]", /\/projects\/#{project_id}/
      end
    end
  end

  test "/projects/:id renders the project title" do
    project_id = '123abc'
    project = {
      name: 'An project',
      type: 'project',
    }.stringify_keys

    Couch::Db.put("/#{project_id}", project)

    get "/projects/#{project_id}"

    assert_response :success

    assert_select "h2", {
      count: 1,
      text: project['name']
    }, 'Expected to see project name'
  end

  test "/projects/:id renders the project's objectives" do
    project_attributes = {
      name: 'An project',
      type: 'project'
    }
    project_id = Couch::Db.post(project_attributes)['id']

    objective_attrs = {
      name: "Increase ROI",
      project_id: project_id,
      type: "objective"
    }
    Couch::Db.post(objective_attrs)

    get "/projects/#{project_id}"

    assert_response :success

    assert_select "h3", {
      count: 1,
      text: objective_attrs[:name]
    }, 'Expected to see objective name'
  end


  test "/projects/:id renders the project's objectives' metrics" do
    project_attributes = {
      name: 'An project',
      type: 'project'
    }
    project_id = Couch::Db.post(project_attributes)['id']

    metric_attrs = {
      name: "Total downloads",
      type: "metric"
    }
    metric_id = Couch::Db.post(metric_attrs)['id']

    objective_attrs = {
      name: "Increase ROI",
      project_id: project_id,
      type: "objective",
      metric_id: metric_id
    }
    Couch::Db.post(objective_attrs)

    get "/projects/#{project_id}"

    assert_response :success

    assert_select "h4", {
      count: 1,
      text: metric_attrs[:name]
    }, 'Expected to see the metric name'
  end
end
