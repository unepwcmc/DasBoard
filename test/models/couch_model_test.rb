require 'test_helper'

class CouchModelTest < ActiveSupport::TestCase
  test '#initialize sets the attributes instance variable' do
    attributes = {o: 'hai'}
    model = Couch::Model.new(attributes)

    assert_equal attributes, model.attributes
  end

  test '#initialize sets the attributes instance variable to an empty hash if
   no attributes are given' do
    model = Couch::Model.new()

    assert_equal({}, model.attributes)
  end

  test '.id returns the _id attribute' do
    model = Couch::Model.new({'_id' => 1})
    assert_equal 1, model.id
  end

  test "#find pulls the given ID from Couch::Db and creates a new instance of model" do
    model_attrs = { id: 4 }
    Couch::Db.expects(:get)
      .with(model_attrs[:id])
      .returns(model_attrs)

    found_model = Couch::Model.find(model_attrs[:id])

    assert_kind_of Couch::Model, found_model,
      "Expected find to return a model"

    assert_equal model_attrs, found_model.attributes,
      "Expected model to have the right attributes"
  end

  test "#save on an already-persisted model updates the model's attributes in
  Couch::Db and gets the updated _rev" do
    model = Couch::Model.new({
      _id: 4,
      _rev: 1,
      name: 'Total uptime'
    }.stringify_keys)

    Couch::Db.expects(:put)
      .with("/#{model.attributes['_id']}", model.attributes)
      .returns({"rev" => 2})

    model.save()

    assert_equal 2, model.attributes['_rev'],
      "Expected model to have updated the '_rev'"
  end

  test ".save on a new model creates a record in Couch::Db and gets the
   _rev" do
    model = Couch::Model.new({
      'name' => 'Total uptime'
    })

    Couch::Db.expects(:post)
      .with(model.attributes)
      .returns({"rev" => 1})

    model.save()

    assert_equal 1, model.attributes['_rev'],
      "Expected model to have updated the '_rev'"
  end

  test ".update updates the model's attributes in Couch::Db" do
    model = Couch::Model.new({
      "_id" => '1234',
      "name" => 'yep',
      "type" => 'pey'
    })

    model.expects(:save).returns(true)

    model.update({"name" => "yep"})

    assert_equal "yep", model.attributes['name'],
      "Expected model name to be changed to 'yep'"

    assert_equal "pey", model.attributes['type'],
      "Expected model attribute 'type' to be untouched"
  end

  test ".update does not update the type" do
    model = Couch::Model.new({
      "_id" => '1234',
      "name" => 'yep',
      "type" => 'pey'
    })

    model.expects(:save).returns(true)

    model.update({"type" => "Sea horse"})

    assert_equal "pey", model.attributes['type'],
      "Expected model type to be untouched"
  end

  test ".update does not update the _id" do
    model = Couch::Model.new({
      "_id" => '1234',
      "name" => 'yep',
      "type" => 'pey'
    })

    model.expects(:save).returns(true)

    model.update({"_id" => "4321"})

    assert_equal "1234", model.id,
      "Expected model _id to be untouched"
  end

  test "#view calls the given view in Couch::Db" do
    Couch::Db.expects(:get)
      .with("_design/couch%2Fmodels/_view/all")
      .returns({
        "rows" => []
      })

    result = Couch::Model.view(:all)

    assert_equal [], result
  end

end
