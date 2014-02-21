window.DasBoard ||= {}

class window.DasBoard.ProjectShowController
  constructor: (@objectiveMetrics) ->
    $('#add-objective').click(@addObjective)
    $('body').on('ajax:success', '.objective-metric-form', @showChangedMetric)
    $('body').on('ajax:error', '.objective-metric-form', @updateMetricError)

    @createMetricCharts()

  showChangedMetric: (event, data, status, xhr) ->
    $formEl = $(event.target)
    $metricEl = $formEl.parents('.metric')

    new MetricChartView($metricEl, new Metric(data.metric))

  updateMetricError: (event, data, status, xhr) ->
    console.log data
    alert('Error saving metric, please reload the page')

  createMetricCharts: ->
    for objectiveId, metric of @objectiveMetrics
      if metric
        $metricEl = $("objective-#{objectiveId}").find('.metric')

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
