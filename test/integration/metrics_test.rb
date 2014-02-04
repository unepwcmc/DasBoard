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

  test "POST /metrics/:id adds a new data point to the metric" do
    metric = Couch::Db.post({name: "Protected planet downloads", type: "metric"})
    post_data = {data: {value: 5, date: 1391505525}}

    post "/metrics/#{metric['id']}/data",
      post_data.to_json,
      "CONTENT_TYPE" => 'application/json'

    updated_metric = Couch::Db.get(metric['id'])

    assert_equal updated_metric['data'].length, 1,
      "Expected the metric to have a data array with 1 element"

    data_point = updated_metric['data'][0]
    assert_equal post_data[:data].stringify_keys, data_point
  end
end
