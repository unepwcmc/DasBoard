require 'test_helper'

class ModelsControllerTest < ActionController::TestCase
  test 'PUT /:id/update updates only the given attributes on the record' do
    model_id = '479'
    model_attrs = {
      "name" => "my little metric",
      "type" => "metric"
    }

    new_model_name = "my big metric"
    updated_model_attrs = model_attrs.merge({"name" => new_model_name})

    Couch::Db.expects(:get)
      .with(model_id)
      .returns(model_attrs)

    Metric.expects(:new)
      .with(model_attrs)
      .returns( Struct.new("Metric", :attributes) {
        def update attrs
        end
      }.new(updated_model_attrs) )

    put :update, {"id" => model_id, "name" => new_model_name}

    assert_response :success

    assert_equal updated_model_attrs, JSON.parse(response.body)
  end
end
