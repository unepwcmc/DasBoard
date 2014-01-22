require 'test_helper'

class ProjectTest < MiniTest::Unit::TestCase
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
end
