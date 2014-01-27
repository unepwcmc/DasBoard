require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'projects/all view turns only project documents with nested objectives' do
    Couch::Db.post({type: "project"})
    Couch::Db.post({type: "not a project"})

    results = Couch::Db.get('_design/projects/_view/all')
    projects = results["rows"]

    assert_equal 1, projects.length,
      "Expected only 1 Project to be returned"

    project = projects[0]["value"]
    assert_equal 'project', project["type"]
  end

  test 'projects/all returns the project with nested objectives' do
    nrt_project = Couch::Db.post({
      name: "NRT",
      type: "project",
      objectives: [
        {name: 'objective 1 tim'},
        {name: 'objective 2 adam'}
      ]
    })

    species_project = Couch::Db.post({
      name: "Species+",
      type: "project",
      objectives: [
        {name: 'objective 2 james'}
      ]
    })

    results = Couch::Db.get('_design/projects/_view/all')
    projects = results['rows']

    assert_equal 2, projects.length

    first_result = projects[0]['value']
    assert_equal nrt_project['id'], first_result['_id'],
      "Expected the first returned project to be NRT"

    assert_kind_of Array, first_result['objectives'],
      "Expected the first result to have an array of nested objectives"
    nested_objectives = first_result['objectives']
    assert_equal 2, nested_objectives.length,
      "Expected the first project to have 2 nested objectives"

    second_result = projects[1]['value']
    assert_equal species_project['id'], second_result['_id'],
      "Expected the second returned project to be species"

    assert_kind_of Array, second_result['objectives'],
      "Expected species to have an array of nested objectives"
    nested_objectives = second_result['objectives']
    assert_equal 1, nested_objectives.length,
      "Expected species to have 1 nested objective"
  end

  test "projects/with_nested_metrics returns projects with the metrics
  associated to their objectives nested " do
    metric = {
      name: "Total downloads",
      type: "metric"
    }
    metric['id'] = Couch::Db.post(metric)['id']

    ppe_project = {
      name: "Protected Planet",
      type: "project",
      objectives: [
        {name: 'increase downloads', metric_id: metric['id']}
      ]
    }
    ppe_project['id'] = Couch::Db.post(ppe_project)['id']

    results = Couch::Db.get(
      '_design/projects/_view/with_nested_metrics?group=true&group_level=1'
    )
    projects = results['rows']

    assert_equal 1, projects.length
    project = projects[0]
    objective = project['objectives'][0]
    
    assert_not_nil objective['metric'],
      "Expected the nested objective to have 'metric' attribute"
    assert_equal objective['metric']['id'], metric['id'],
      "Expected the nested metric to have the correct id"
  end

end
