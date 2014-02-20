require 'test_helper'

class ObjectivesTest < ActionDispatch::IntegrationTest

  test "/project/:id/objectives/new renders the objective view for a new objective" do
    get '/projects/3434/objectives/new'

    assert_response :success

    assert_select ".objective" do
      assert_select "h3", {
        text: "New Objective"
      }
    end

    assert_select ".objective", {
      text: /No metric selected/
    }

    assert_template partial: "_select_metric"

    assert_select "form", {
      count: 1
    }
  end

  test "PUT /objectives/:id updates the objective and returns the objective as JSON" do
    objective = Objective.new(metric_id: nil)
    objective.save

    metric = Metric.new(name: "an metric")
    metric.save

    put "/objectives/#{objective.id}", metric_id: metric.id

    updated_objective = JSON.parse(response.body)

    assert_equal objective.id, updated_objective['_id']
    assert_not_nil updated_objective['metric']

    returned_metric = updated_objective['metric']
    assert_equal metric.id, returned_metric['_id']
  end
end
