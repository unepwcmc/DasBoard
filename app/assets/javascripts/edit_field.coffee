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
    url = @$el.attr('data-url')
    modelType = @$el.attr('data-model-type')
    fieldName = @$el.attr('data-field-name')

    data = {}
    data[modelType] = {}
    data[modelType][fieldName] = @$el.text()

    $.ajax(
      type: "PUT",
      url: url
      data: JSON.stringify(data)
      contentType: 'application/json'
    ).success(
      @close
    ).fail(->
      alert('Error updating, please reload the page')
    )

  close: =>
    @$el.attr('contenteditable', false)
    @$editControls.remove()
