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
    nrt_project = Couch::Db.post({name: "NRT", type: "project"})
    species_project = Couch::Db.post({name: "Species+", type: "project"})

    first_child_of_nrt = Couch::Db.post({
      project_id: nrt_project['id'],type: "objective", name: "objective 1 tim"
    })
    second_child_of_nrt = Couch::Db.post({
      project_id: nrt_project['id'],type: "objective", name: "objective 2 adam"
    })
    child_of_species = Couch::Db.post({
      project_id: species_project['id'],type: "objective", name: "objective 3 james"
    })

    results = Couch::Db.get('_design/projects/_view/with_nested_objectives?group=true&group_level=1')

    assert_equal 2, results['rows'].length

    first_result = results['rows'][0]['value']
    assert_equal nrt_project['id'], first_result['_id'],
      "Expected the first returned project to be NRT"

    assert_kind_of Array, first_result['objectives'],
      "Expected the first result to have an array of nested objectives"
    nested_objectives = first_result['objectives']
    assert_equal 2, nested_objectives.length,
      "Expected the first project to have 2 nested objectives"

    nested_objective_ids = nested_objectives.map{|objective| objective['_id']}

    assert nested_objective_ids.include?(first_child_of_nrt['id']),
      "Expected NRT to have the first child nested"
    assert nested_objective_ids.include?(second_child_of_nrt['id']),
      "Expected NRT to have the second child nested"


    second_result = results['rows'][1]['value']
    assert_equal species_project['id'], second_result['_id'],
      "Expected the second returned project to be species"

    assert_kind_of Array, second_result['objectives'],
      "Expected species to have an array of nested objectives"
    nested_objectives = second_result['objectives']
    assert_equal 1, nested_objectives.length,
      "Expected species to have 1 nested objective"

    nested_objective_ids = nested_objectives.map{|objective| objective['_id']}

    assert nested_objective_ids.include?(child_of_species['id']),
      "Expected species to have the correct nested objective"
  end
end
