class window.AddObjectiveView
  constructor: (@projectId) ->
    @renderLoading()
    @$el.on('click', 'button', @createObjective)
    @getMetrics()

  template: Handlebars.compile("""
    <input value="New Objective">
    <select>
      {{#each metrics}}
        <option value="{{id}}">{{value.name}}</option>
      {{/each}}
    </select>
    <button class="small">Create</button>
  """)

  render: =>
    @$el.html($(@template(metrics: @metrics)))

  renderLoading: ->
    @$el = $("""
      <div class="edit-form">
        Loadin'...
      </div>
    """)
    $('#add-objective').after(@$el)

  getMetrics: ->
    $.getJSON("/metrics")
      .success( (metrics) =>
        @metrics = metrics
        @render()
      ).fail( ->
        alert("error getting metrics, contact your local webmaster")
        console.log arguments
      )

  getSelectedMetricId: ->
    @$el.find('select').val()

  createObjective: =>
    objective =
      name: @$el.find('input').val()
      project_id: @projectId
      type: 'objective'
      metric_id: @getSelectedMetricId()

    $.ajax(
      type: "POST"
      url: "/objectives"
      contentType: "application/json"
      data: JSON.stringify(
        objective: objective
      )
    ).success(
      @close
    ).fail( (err) ->
      alert("error creating objective, contact your local webmaster")
    )
    
    objective

  close: ->
    location.reload()
