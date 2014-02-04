class window.MetricChartView
  constructor: (@objective, @metric) ->
    unless @metric?
      throw new Error("No metric provided, can't create MetricChartView")

    @render()

  render: ->
    @$canvas = @getCanvas()

    context = @$canvas.get(0).getContext("2d")
    @chart = new Chart(context).Line(
      labels : ["January","February","March","April","May","June","July"],
      datasets : [
        {
          fillColor : "rgba(220,220,220,0.5)",
          strokeColor : "rgba(220,220,220,1)",
          pointColor : "rgba(220,220,220,1)",
          pointStrokeColor : "#fff",
          data : [65,59,90,81,56,55,40]
        },
        {
          fillColor : "rgba(151,187,205,0.5)",
          strokeColor : "rgba(151,187,205,1)",
          pointColor : "rgba(151,187,205,1)",
          pointStrokeColor : "#fff",
          data : [28,48,40,19,96,27,100]
        }
      ]
    )

  getCanvas: ->
    $("section##{@objective._id} #metric-#{@metric._id}")

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
