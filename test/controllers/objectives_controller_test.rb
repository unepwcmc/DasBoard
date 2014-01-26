require 'test_helper'

class ObjectivesControllerTest < ActionController::TestCase
  def test_show_gets_the_objective
    objective_id = '5'

    Couch::Db.
      expects(:get).
      with("/#{objective_id}").
      returns({
        "name" => 'super objective',
      })

    get :show, id: objective_id

    assert_response :success

    assigned_objective = assigns(:objective)
    assert_not_nil assigned_objective, 'Expected @objective to be assigned'
    assert_equal 'super objective', assigned_objective['name']
  end

end
