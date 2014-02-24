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

  test "GET /metrics/new creates a new metric in the database" do
    assert_difference('Metric.count', 1) do
      get :new
    end

    assert_equal "New Metric", assigns(:metric).name
    assert_response :redirect
  end


  test "GET /metrics/:id fetches the correct metric" do
    metric = Metric.new(id:5, name: "test")
    Metric.expects(:find)
      .with(metric.id.to_s)
      .returns(metric)

    get :show, id: metric.id

    assert_response :success
    assert_equal metric, assigns(:metric)
  end

  test "PUT /metrics/:id updates the metric" do
    metric = Metric.create(name: "test")

    new_name = "After dinner"

    get :update, id: metric.id, metric: {name: new_name}

    assert_response :success

    metric.reload
    assert_equal new_name, metric.name
  end
end
