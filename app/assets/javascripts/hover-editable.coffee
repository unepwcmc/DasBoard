
class window.window.HoverEditable
  currentHoverTab: null

  @bindToEditables: ->
    $("body").on(
      'mouseenter', '[data-behavior="hover-edit"]', HoverEditable.showEditTab
    )
    $("body").on(
      'mouseleave', '[data-behavior="hover-edit"]', HoverEditable.hideEditTab
    )

  @showEditTab: ->
    # Unless there is an existing edit happening
    unless $(@).attr('contenteditable') is 'true'
      HoverEditable.closeExistingTab()
      HoverEditable.currentHoverTab = new HoverTab($(@))

  @hideEditTab: ->
    HoverEditable.timeout = setTimeout(->
      HoverEditable.currentHoverTab.close()
    , 200)

  @closeExistingTab: ->
    if HoverEditable.timeout?
      clearTimeout(HoverEditable.timeout)

    if HoverEditable.currentHoverTab?
      HoverEditable.currentHoverTab.close()

class HoverTab
  constructor: (@$target) ->
    @render()
    @setPosition()
    @hovering = false

  render: ->
    @$el = $("<div class='hover-edit-tab'>Edit</div>")
    $('body').append(@$el)
    @$el.hover(
      (=> @hovered = true),
      (=> @hovered = false)
    )
    @$el.click(@createEditView)

  createEditView: =>
    new EditField(@$target)

  setPosition: ->
    offset = @$target.offset()
    offset.left = offset.left - 50
    @$el.offset(offset)

  close: =>
    if @hovered
      @$el.mouseout(@close)
    else
      @$el.remove()

class EditField
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
