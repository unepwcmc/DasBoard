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
      objectives: []
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
      objectives: [
        {name: 'objective 1 tim'}
      ]
    }
    project_id = Couch::Db.post(project_attributes)['id']

    get "/projects/#{project_id}"

    assert_response :success

    assert_select "h3", {
      count: 1,
      text: project_attributes[:objectives][0][:name]
    }, 'Expected to see objective name'
  end

end
