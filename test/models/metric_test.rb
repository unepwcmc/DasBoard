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
end
