class window.window.HoverEditable
  currentHoverTab: null

  @bindToEditables: ->
    $("body").on(
      'mouseenter', '[data-behavior="hover-edit"]', HoverEditable.showEditTab
    )
    #$("body").on(
      #'mouseleave', '[data-behavior="hover-edit"]', HoverEditable.hideEditTab
    #)

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
    @$el = $("<div class='hover-edit-tab'></div>")
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
