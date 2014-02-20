module ProjectHelper

  def editable_tag model, attribute, tag_name
    content_tag(tag_name, model.send(attribute), {
      "data-behavior" => "hover-edit",
      "data-model-id" => model.id,
      "data-model-type" => model.class.to_s.pluralize.downcase,
      "data-field-name" => attribute
    })
  end

end
