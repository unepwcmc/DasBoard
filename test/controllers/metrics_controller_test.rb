require 'test_helper'

class MetricsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "POST /metrics/:id/data gets the metric with :id, calls add_data and
   succeeds" do
    metric_id = '5'
    metric = Metric.new({
      id: metric_id,
      name: "Total downoads"
    })

    post_data = {
      id: metric_id,
      data: {"value" => "5", "date" => "1391505525"}
    }

    Metric.expects(:find)
      .with(metric_id)
      .returns(metric)

    metric.expects(:add_data_point)
      .with(post_data[:data])

    metric.expects(:save)

    post "data", post_data

    assert_response :success
  end
end
