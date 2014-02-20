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
    modelType = @$el.attr('data-model-type')
    fieldName = @$el.attr('data-field-name')

    data = {}
    data[fieldName] = @$el.text()

    $.ajax(
      type: "PUT",
      url: "/#{modelType}/#{modelId}"
      data: data
    ).success(
      @close
    ).fail(->
      alert('Error updating, please reload the page')
    )

  close: =>
    @$el.attr('contenteditable', false)
    @$editControls.remove()
