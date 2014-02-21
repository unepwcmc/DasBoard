window.DasBoard ||= {}

class window.DasBoard.ProjectShowController
  constructor: (@objectiveMetrics) ->
    $('#add-objective').click(@addObjective)

    @setupBindings()
    @createMetricCharts()

  setupBindings: ->
    $('body').on('ajax:success', '.objective-metric-form', @showChangedMetric)
    $('body').on('ajax:success', '.delete-objective', @removeObjective)

    $('body').on(
      'ajax:error',
      '.objective-metric-form .delete-objective',
      @updateError
    )

  showChangedMetric: (event, data, status, xhr) ->
    $formEl = $(event.target)
    $metricEl = $formEl.parents('.metric')

    new MetricChartView($metricEl, new Metric(data.metric))

  removeObjective: (event, data) ->
    $("#objective-#{data.id}").remove()

  updateError: (event, data, status, xhr) ->
    console.log data
    alert('Error saving, please reload the page')

  createMetricCharts: ->
    for objectiveId, metric of @objectiveMetrics
      if metric
        $metricEl = $("#objective-#{objectiveId}").find('.metric')

        new MetricChartView(
          $metricEl,
          new Metric(metric)
        )

  addObjective: (event) ->
    projectId = $(event.target).attr('data-project-id')

    $.ajax(
      url: "/projects/#{projectId}/objectives/new"
    ).success(
      renderNewObjective
    ).fail(->
      alert('Unable to load new objective, please reload the page')
    )

renderNewObjective = (response) ->
  newObjectiveEl = $(response)
  $("#objectives").append(newObjectiveEl)

  objectiveNameEl = $(newObjectiveEl.find('h3'))
  new EditField(objectiveNameEl)
