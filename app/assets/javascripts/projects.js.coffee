class window.MetricChartView
  constructor: (@objective, @metric) ->
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
    @render()
    @$el.find('button').click(@createObjective)

  render: ->
    @$el = $("""
      <div class="edit-form">
        <input value="New Objective">
        <button class="small">Create</button>
      </div>
    """)
    $('#add-objective').after(@$el)

  createObjective: =>
    objective =
      name: @$el.find('input').val()
      project_id: @projectId
      type: 'objective'

    $.ajax(
      type: "POST"
      url: "/objectives"
      data: objective
    ).success( ->
      location.reload()
    ).fail( (err) ->
      alert("error creating objective, contact your local webmaster")
    )
    
    objective
