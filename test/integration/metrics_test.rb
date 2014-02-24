require 'test_helper'

class MetricsTest < ActionDispatch::IntegrationTest

  test "/metrics renders a list of metrics as JSON" do
    metrics = [
      Metric.create({name: "Metric 1"}),
      Metric.create({name: "Metric 2"})
    ]

    get '/metrics'

    assert_response :success

    results = JSON.parse(response.body)

    assert_equal results.length, 2,
      "Expected the 2 metrics to be returned"

    metric_1_results = results.select do |result|
      result['name'] == metrics.first.name
    end
    assert_equal metric_1_results.length, 1,
      "Expected to see metric 1 once"

    metric_2_results = results.select do |result|
      result['name'] == metrics.last.name
    end
    assert_equal metric_2_results.length, 1,
      "Expected to see metric 2 once"
  end

  test "POST /metrics/:id/ adds a new data point to the metric" do
    metric = Metric.create({name: "Protected planet downloads"})
    post_data = {data: {value: 5, date: 1391505525}}

    post "/metrics/#{metric.id}/data",
      post_data.to_json,
      "CONTENT_TYPE" => 'application/json'

    updated_metric = metric.reload

    assert_equal 1, updated_metric.data.length,
      "Expected the metric to have a data array with 1 element"

    data_point = updated_metric.data.first
    assert_equal post_data[:data].stringify_keys, data_point
  end

  test "/metrics/new redirects to a metric page for a new metric" do
    get "/metrics/new"

    assert_redirected_to metric_path(assigns(:metric))
  end

  test "/metrics/show shows the title of the metric" do
    metric = Metric.create(name: "My Metric")

    get "/metrics/#{metric.id}"

    assert_select 'h1', {
      text: "My Metric"
    }
  end
end
