require 'test_helper'

class ObjectivesTest < ActionDispatch::IntegrationTest

  test "/project/:id/objectives/new renders the objective view for a new objective" do
    get '/projects/3434/objectives/new'

    assert_response :success

    assert_select ".objective" do
      assert_select "h3", {
        text: "Enter the name of the new objective"
      }
    end

    assert_template partial: "_select_metric"

    assert_select "form", {
      count: 1
    }

    assert_select 'a[href="/metrics/new"]', {
      count: 1
    }
  end

  test "PUT /objectives/:id updates the objective and returns the objective as JSON" do
    objective = Objective.create(metric_id: nil)

    metric = Metric.create(name: "an metric")

    put "/objectives/#{objective.id}", objective: {metric_id: metric.id}

    updated_objective = JSON.parse(response.body)

    assert_equal objective.id, updated_objective['id']
    assert_not_nil updated_objective['metric']

    returned_metric = updated_objective['metric']
    assert_equal metric.id, returned_metric['id']
  end

  test "PUT /objectives/:id with a threshold number updates the threshold" do
    objective = Objective.create()

    put "/objectives/#{objective.id}", objective: {threshold: 42}

    updated_objective = JSON.parse(response.body)

    assert_equal objective.id, updated_objective['id']
    assert_equal 42.0, updated_objective['threshold']
  end
end
