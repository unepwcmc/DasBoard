require 'test_helper'

class MetricsTest < ActionDispatch::IntegrationTest

  test "/metrics renders a list of metrics as JSON" do
    Couch::Db.post({name: "Metric 1", type: "metric"})
    Couch::Db.post({name: "Second Metric", type: "metric"})
    Couch::Db.post({name: "Not a metric", type: "project"})

    get '/metrics'

    assert_response :success

    results = JSON.parse(response.body)

    assert_equal results.length, 2,
      "Expected the 2 metrics to be returned"

    metric_1_results = results.select do |result|
      result['value']['name'] == "Metric 1"
    end
    assert_equal metric_1_results.length, 1,
      "Expected to see metric 1 once"

    metric_2_results = results.select do |result|
      result['value']['name'] == "Second Metric"
    end
    assert_equal metric_2_results.length, 1,
      "Expected to see metric 2 once"
  end

end
