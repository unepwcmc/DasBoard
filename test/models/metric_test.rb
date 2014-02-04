require 'test_helper'

class MetricTest < ActiveSupport::TestCase
  test '#initialize sets the attributes instance variable' do
    attributes = {o: 'hai'}
    metric = Metric.new(attributes)

    assert_equal attributes, metric.attributes
  end

  test '#initialize sets the attributes instance variable to an empty hash if
   no attributes are given' do
    metric = Metric.new()

    assert_equal({}, metric.attributes)
  end

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

    assert_kind_of Array, metric.attributes[:data],
      "Expected the metric to gain a data array"

    assert_equal metric.attributes[:data].length, 1

    added_point = metric.attributes[:data][0]
    assert_equal data_point, added_point,
      "Expected the data point to be added correctly"
  end

  test ".add_data_point on a metric with an existing 'data' attribute
  creates the 'data' array and adds the given point data" do
    metric = Metric.new({
      data: [{
        value: '8',
        date: '456',
      }]
    })

    data_point = {value: '4', date: '789'}
    metric.add_data_point(data_point)

    assert_equal metric.attributes[:data].length, 2

    added_point = metric.attributes[:data][1]
    assert_equal data_point, added_point,
      "Expected the data point to be added correctly"
  end

  test "#find pulls the given ID from Couch::Db and creates a new instance of metric" do
    metric_attrs = {
      id: 4,
      name: 'Total uptime'
    }
    Couch::Db.expects(:get)
      .with(metric_attrs[:id])
      .returns(metric_attrs)

    found_metric = Metric.find(metric_attrs[:id])

    assert_kind_of Metric, found_metric,
      "Expected find to return a metric"

    assert_equal metric_attrs, found_metric.attributes,
      "Expected metric to have the right attributes"
  end

  test "#save on an already-persisted model updates the model's attributes in
  Couch::Db and gets the updated _rev" do
    metric = Metric.new({
      _id: 4,
      _rev: 1,
      name: 'Total uptime'
    }.stringify_keys)

    Couch::Db.expects(:put)
      .with("/#{metric.attributes['_id']}", metric.attributes)
      .returns({"rev" => 2})

    metric.save()

    assert_equal 2, metric.attributes['_rev'],
      "Expected metric to have updated the '_rev'"
  end
end
