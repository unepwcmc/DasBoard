module ProjectHelper

  def editable_tag model, attribute, tag_name
    content_tag(tag_name, model[attribute], {
      "data-behavior" => "hover-edit",
      "data-model-id" => model['_id'],
      "data-field-name" => attribute
    })
  end

end
