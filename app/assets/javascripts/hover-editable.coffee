
class window.window.HoverEditable
  currentHoverTab: null

  @bindToEditables: ->
    $('[data-behavior="hover-edit"]').hover(
      HoverEditable.showEditTab,
      HoverEditable.hideEditTab
    )

  @showEditTab: ->
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

  createEditControls: ->
    $("""
      <div>
        <input type='submit' value='Save'><a href='#'>cancel</a>
     </div>
    """)

  restoreAndClose: =>
    @$el.text(@previousValue)
    @$el.attr('contenteditable', false)
    @$editControls.remove()
