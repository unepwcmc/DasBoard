require 'test_helper'

class ProjectViewsTest < ActiveSupport::TestCase
  test '_design/project/_view/with_objectives returns the projects with their objectives' do
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

    result = Couch::Db.get('_design/projects/_view/with_objectives')
    projects = result['rows']

    assert_equal 5, projects.length,
      "Expected there to be a row for each record"

    nrt_project_row = projects[0]
    assert_equal nrt_project_row['key'], [nrt_project['id'], 0, 'project'],
      "Expected the first row to have the correct key for the NRT project"
    assert_equal nrt_project_row['value']['name'], 'NRT',
      "Expected the first row to have the values for the NRT project"

    nrt_objective_1 = projects[1]
    assert_equal nrt_objective_1['key'], [nrt_project['id'], 1, 'objective'],
      "Expected the 2nd row to have the correct key for the first NRT objective"
    assert_equal nrt_objective_1['value']['name'], 'objective 1 tim',
      "Expected the 2nd row to have the values for the NRT project"

    nrt_objective_2 = projects[2]
    assert_equal nrt_objective_2['key'], [nrt_project['id'], 1, 'objective'],
      "Expected the third row to have the correct key for the first NRT objective"
    assert_equal nrt_objective_2['value']['name'], 'objective 2 adam',
      "Expected the third row to have the values for the NRT project"

    species_project_row = projects[3]
    assert_equal species_project_row['key'], [species_project['id'], 0, 'project'],
      "Expected the forth row to have the correct key for the Species+ project"
    assert_equal species_project_row['value']['name'], 'Species+',
      "Expected the forth row to have the values for the Species+ project"

    species_objective = projects[4]
    assert_equal species_objective['key'], [species_project['id'], 1, 'objective'],
      "Expected the third row to have the correct key for the first Species+ objective"
    assert_equal species_objective['value']['name'], 'objective 3 james',
      "Expected the third row to have the values for the Species+ project"
  end
end
