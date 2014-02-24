require 'test_helper'

class ObjectivesControllerTest < ActionController::TestCase

  test "GET :new creates a new objective on the given project"  do
    project_id = 5
    get :new, id: project_id

    assert_response :success

    new_objective = assigns(:objective)
    assert_not_nil new_objective, "Expected @objective to be an objective"
    assert_equal "New Objective", new_objective.name
    assert_equal project_id, new_objective.project_id,
      "Expected the new objective to be associated to the given project"
  end

  test "GET :new assigns the list of metrics" do
    metrics = [Metric.new({
      name: "Anne metric"
    })]

    Metric.expects(:all)
      .returns(metrics)

    get :new, id: '5'

    assigned_metrics = assigns(:metrics)

    assert_not_nil assigned_metrics

    assert_equal metrics, assigned_metrics
  end

  test "PUT /objectives/:id updates the objective" do
    objective = Objective.new(metric_id: nil)
    objective.save

    metric = Metric.create()

    put :update, id: objective.id, objective: {metric_id: metric.id}

    updated_objective = Objective.find(objective.id)

    assert_equal metric.id, updated_objective.attributes['metric_id']
  end

  test "PUT /objectives/:id updates the objective name" do
    objective = Objective.new()
    objective.save

    put :update, id: objective.id, objective: {name: "test"}

    updated_objective = Objective.find(objective.id)

    assert_equal "test", updated_objective.name
  end

  test "DELETE /objectives/:id destroys the objective" do
    objective = Objective.create

    assert_response :success
    assert_difference 'Objective.count', -1 do
      delete :destroy, id: objective.id
    end
  end
end
