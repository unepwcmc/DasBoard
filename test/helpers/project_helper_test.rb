require 'test_helper'

class ProjectHelperTest < ActionView::TestCase

  test "#editable_tag given a model and attribute name generates the correct
  data attribute tags" do
    objective = Objective.new({
      id: 54,
      name: "Lovely"
    })

    self.expects(:content_tag)
      .with(:h3, objective.name, {
        "data-behavior" => "hover-edit",
        "data-url" => "/objectives/#{objective.id}",
        "data-model-type" => 'objective',
        "data-field-name" => 'name'
      }).returns('HTML')

    html = editable_tag objective, 'name', :h3

    assert_kind_of String, html
  end

end
