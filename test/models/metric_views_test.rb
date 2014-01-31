require 'test_helper'

class MetricViewsTest < ActiveSupport::TestCase
  test '_design/metrics/_view/all returns only metric documents' do
    Couch::Db.post({type: "metric"})
    Couch::Db.post({type: "objective"})

    result = Couch::Db.get('_design/metrics/_view/all')
    metrics = result['rows']

    assert_equal 1, metrics.length,
      "Expected only 1 Metric to be returned"

    metric = metrics[0]["value"]
    assert_equal 'metric', metric["type"]
  end
end
