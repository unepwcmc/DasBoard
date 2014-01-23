require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def test_that_projects_all_returns_only_project_documents
    Couch::Db.post({type: "project"})
    Couch::Db.post({type: "not a project"})

    results = Couch::Db.get('_design/projects/_view/all')
    projects = results["rows"]

    assert_equal 1, projects.length,
      "Expected only 1 Project to be returned"

    project = projects[0]["value"]
    assert_equal 'project', project["type"]
  end

  test 'projects/with_nested_objectives returns the project objectives' do
    project_with_2_objectives = Couch::Db.post({type: "project"})
    project_with_1_objective = Couch::Db.post({type: "project"})

    Couch::Db.post({
      project_id: project_with_2_objectives['id'],type: "objective"
    })
    Couch::Db.post({
      project_id: project_with_2_objectives['id'],type: "objective"
    })
    Couch::Db.post({
      project_id: project_with_1_objective['id'],type: "objective"
    })

    results = Couch::Db.get('_design/projects/_view/with_nested_objectives')

    assert_equal 2, results['rows']

    assert_equal 2, results['rows'][0]['value']
    assert_equal 1, results['rows'][1]['value']
  end
end
