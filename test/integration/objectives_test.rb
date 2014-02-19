require 'test_helper'

class ObjectivesTest < ActionDispatch::IntegrationTest

  test "/project/:id/objectives/new renders the objective view for a new objective" do
    get '/projects/3434/objectives/new'

    assert_response :success

    assert_select ".objective" do
      assert_select "h3", {
        text: "New Objective"
      }
    end

    assert_select ".objective", {
      text: /No metric selected/
    }

    assert_template partial: "_select_metric"
  end

end
