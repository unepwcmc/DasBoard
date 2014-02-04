require 'test_helper'

class MetricTest < ActiveSupport::TestCase
  test '#all returns only metric documents' do
    Couch::Db.post({type: "metric"})
    Couch::Db.post({type: "objective"})

    metrics = Metric.all

    assert_equal 1, metrics.length,
      "Expected only 1 Metric to be returned"

    metric = metrics[0]["value"]
    assert_equal 'metric', metric["type"]
  end

  test ".add_data_point on a metric with no existing 'data' attribute
  creates the 'data' array and adds the given point data" do
    metric = Metric.new({})

    data_point = {value: '4', date: '123'}
    metric.add_data_point(data_point)

    assert_kind_of Array, metric.attributes['data'],
      "Expected the metric to gain a data array"

    assert_equal metric.attributes['data'].length, 1

    added_point = metric.attributes['data'][0]
    assert_equal data_point, added_point,
      "Expected the data point to be added correctly"
  end

  test ".add_data_point on a metric with an existing 'data' attribute
  creates the 'data' array and adds the given point data" do
    metric = Metric.new({
      'data' => [{
        value: '8',
        date: '456',
      }]
    })

    data_point = {value: '4', date: '789'}
    metric.add_data_point(data_point)

    assert_equal 2, metric.attributes['data'].length

    added_point = metric.attributes['data'][1]
    assert_equal data_point, added_point,
      "Expected the data point to be added correctly"
  end
end
