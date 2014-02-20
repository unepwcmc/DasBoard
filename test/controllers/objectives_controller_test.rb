require 'test_helper'

class ObjectivesControllerTest < ActionController::TestCase

  test "GET :new creates a new objective on the given project"  do
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

  test "GET :new assigns the list of metrics" do
    metrics = [{"value" => {
      "name" => "Anne metric"
    }}]

    Metric.expects(:view)
      .with('all')
      .returns(metrics)

    get :new, id: 'anID'

    assigned_metrics = assigns(:metrics)
    expected_metrics = metrics.map{|m|m["value"]}

    assert_not_nil assigned_metrics

    assert_equal expected_metrics, assigned_metrics
  end

  test "PUT /objectives/:id updates the objective" do
    objective = Objective.new(metric_id: nil)
    objective.save

    metric = Metric.new()
    metric_id = metric.id

    Metric.expects(:find)
      .with(metric_id)
      .returns(metric)

    put :update, id: objective.id, metric_id: metric_id

    updated_objective = Objective.find(objective.id)

    assert_equal metric_id, updated_objective.attributes['metric_id']
  end

end
