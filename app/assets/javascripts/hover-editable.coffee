
class window.window.HoverEditable
  currentHoverTab: null

  @bindToEditables: ->
    $('[data-behavior="hover-edit"]').hover(
      HoverEditable.showEditTab,
      HoverEditable.hideEditTab
    )

  @showEditTab: ->
    HoverEditable.currentHoverTab = new HoverTab($(@))

  @hideEditTab: ->
    HoverEditable.currentHoverTab.close()

class HoverTab
  constructor: (@$target) ->
    @render()
    @setPosition()

  render: ->
    @$el = $("<div width='50px'>Edit</div>")
    $('body').append(@$el)

  setPosition: ->
    offset = @$target.offset()
    offset.left = offset.left - 50
    console.log offset
    @$el.offset(offset)

  close: ->
    @$el.remove()
