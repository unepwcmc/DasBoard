module ProjectHelper

  def editable_tag model, attribute, tag_name
    model_name = model.class.to_s.downcase

    content_tag(tag_name, model.send(attribute), {
      "data-behavior" => "hover-edit",
      "data-url" => self.send("#{model_name}_path", model),
      "data-model-type" => model_name,
      "data-field-name" => attribute
    })
  end

end
