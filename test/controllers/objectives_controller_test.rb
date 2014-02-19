require 'test_helper'

class ObjectivesControllerTest < ActionController::TestCase

  test ":new creates a new objective on the given project"  do
    project_id = "5f43"
    get :new, id: project_id

    assert_response :success

    new_objective = assigns(:objective)
    assert_not_nil new_objective, "Expected @objective to be an objective"
    assert_equal "New Objective", new_objective.attributes['name']
    assert_equal "objective", new_objective.attributes['type'],
      "Expected the objective to be of type 'objective'"
    assert_equal project_id, new_objective.attributes['project_id'],
      "Expected the new objective to be associated to the given project"
  end

end
