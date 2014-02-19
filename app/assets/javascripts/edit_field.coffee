class window.EditField
  constructor: (@$el)->
    @previousValue = @$el.text()
    @render()

  render: ->
    @$el.attr('contenteditable', true)
    @$el.focus()
    @$editControls = @createEditControls()
    @$el.after(@$editControls)
    @$editControls.find('a').click(@restoreAndClose)
    @$editControls.find('input').click(@saveUpdate)

  createEditControls: ->
    $("""
      <div>
        <input type='submit' value='Save changes'> or <a href='#'>cancel</a>
      </div>
    """)

  restoreAndClose: =>
    @$el.text(@previousValue)
    @close()

  saveUpdate: =>
    modelId = @$el.attr('data-model-id')
    fieldName = @$el.attr('data-field-name')

    data = {model: {}}
    data.model[fieldName] = @$el.text()

    $.ajax(
      type: "PUT",
      url: "/models/#{modelId}"
      data: data
    ).success(
      @close
    ).fail(->
      alert('Error updating, please reload the page')
    )

  close: =>
    @$el.attr('contenteditable', false)
    @$editControls.remove()
