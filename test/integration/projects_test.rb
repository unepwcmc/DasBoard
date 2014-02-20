require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest

  test "/projects renders a list of projects links by name" do
    project_attributes = {
      name: 'An project'
    }

    project = Project.create(project_attributes)

    get '/projects'

    assert_response :success

    assert_select "ul#projects" do
      assert_select "li", {
        count: 1,
        text: project.name
      }, 'Expected to see project name'

      assert_select "a" do
        assert_select "[href=?]", /\/projects\/#{project.id}/
      end
    end
  end

  test "/projects/:id renders the project title" do
    project = Project.create({
      name: 'An project'
    })

    get "/projects/#{project.id}"

    assert_response :success

    assert_select "h2", {
      count: 1,
      text: project.name
    }, 'Expected to see project name'
  end

  test "/projects/:id renders the project's objectives" do
    project = Project.create({name: 'An project'})

    objective_attrs = {
      name: "Increase ROI",
      project_id: project.id
    }
    objective = Objective.create(objective_attrs)

    get "/projects/#{project.id}"

    assert_response :success

    assert_select "##{objective.id}", {
      count: 1
    }, "Expected to see an element with the objective id"
    assert_select "h3", {
      count: 1,
      text: objective_attrs[:name]
    }, 'Expected to see objective name'
  end


  test "/projects/:id renders the project's objectives' metrics" do
    project = Project.create({name: 'An project'})

    metric = Metric.create({name: "Total downloads"})

    Objective.create({
      name: "Increase ROI",
      project_id: project.id,
      metric_id: metric.id
    })

    get "/projects/#{project.id}"

    assert_response :success

    assert_select "canvas#metric-#{metric.id}", {
      count: 1,
    }, 'Expect to see a metric placeholder'
  end
end
