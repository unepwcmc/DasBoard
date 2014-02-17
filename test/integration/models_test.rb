require 'test_helper'

class ModelsTest < ActionDispatch::IntegrationTest

  test "PUT /models/:id updates the model's attributes in Couch Database" do
    metric = Metric.new({
      "type" => "metric",
      "name" => "Fancy banana"
    })
    metric.save

    updated_name = "Corporate banana"
    put "/models/#{metric.id}", {
      "model" => {
        "name" => updated_name
      }
    }

    assert_response :success

    updated_metric_attrs = JSON.parse(response.body)

    assert_equal updated_name, updated_metric_attrs["name"],
      "Expected updated metric to be returned"

    updated_metric = Metric.find(metric.id)

    assert_equal updated_name, updated_metric.attributes['name'],
      "Expected metric to be updated with name '#{updated_name}'"
  end

end
