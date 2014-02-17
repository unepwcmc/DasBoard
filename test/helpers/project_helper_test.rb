require 'test_helper'

class ProjectHelperTest < ActionView::TestCase

  test "#editable_tag given a model and attribute name generates the correct
  data attribute tags" do
    objective_attrs = {
      "_id" => 54,
      "name" => "Lovely"
    }

    self.expects(:content_tag)
      .with(:h3, objective_attrs['name'], {
        "data-behavior" => "hover-edit",
        "data-model-id" => objective_attrs['_id'],
        "data-field-name" => 'name'
      }).returns('HTML')

    html = editable_tag objective_attrs, 'name', :h3

    assert_kind_of String, html
  end

end
