require 'test_helper'

class ModelsTest < ActionDispatch::IntegrationTest

  test "PUT /models/:id updates the model's attributes in Couch Database" do
    objective = Objective.new({
      "type" => "objective",
      "name" => "Fancy banana"
    })
    objective.save

    updated_name = "Corporate banana"
    put "/models/#{objective.id}", {
      "model" => {
        "name" => updated_name
      }
    }

    assert_response :success

    updated_objective_attrs = JSON.parse(response.body)

    assert_equal updated_name, updated_objective_attrs["name"],
      "Expected updated objective to be returned"

    updated_objective = Objective.find(objective.id)

    assert_equal updated_name, updated_objective.attributes['name'],
      "Expected objective to be updated with name '#{updated_name}'"
  end

end
