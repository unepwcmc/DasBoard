require 'test_helper'

class ProjectsTest < ActionDispatch::IntegrationTest
  test "/projects renders a list of projects by name" do
    project = {
      name: 'An project',
      type: "project"
    }.stringify_keys

    Couch::Db.
      expects(:get).
      with('_design/projects/_view/all').
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

  test "/projects renders the list of objectives for each project" do
    project = {
      id: 'abc',
      name: 'An project',
      type: "project"
    }.stringify_keys

    objective = {
      id: 'xyz',
      type: "objective",
      project_id: project['id'],
      title: 'objective 1'
    }

    objective2 = {
      id: 'xyy',
      type: "objective",
      project_id: project['id'],
      title: 'objective 2'
    }

    results = [
      {
        id: project['id'],
        key: [project['id'], 0],
        value: project
      }, {
        id: objective['id'],
        key: [project['id'], 1, 'objective'],
        value: objective
      }, {
        id: objective2['id'],
        key: [project['id'], 1, 'objective'],
        value: objective2
      }
    ]

    Couch::Db.
      expects(:get).
      with('_design/projects/_view/all').
      returns({'rows' => results})

    get '/projects'

    assert_response :success

    assert_select "ul#projects" do
      assert_select "li", {
        count: 1,
        text: project['name']
      }, 'Expected to see project name'

      assert_select "ul" do
        assert_select "li", { count: 2 }, 'Expected to see project name'
        assert_select "li:first-child", { text: objective['title'] }
        assert_select "li:last-child", { text: objective2['title'] }
      end
    end

  end
end
