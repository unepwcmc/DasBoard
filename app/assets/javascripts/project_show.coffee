window.DasBoard ||= {}

class window.DasBoard.ProjectShowController
  constructor: (@objectives) ->
    $('#add-objective').click(@addObjective)
    $('body').on('ajax:success', '.objective-metric-form', @showChangedMetric)

    @createMetricCharts()

  showChangedMetric: (event, data, status, xhr) ->
    $formEl = $(event.target)
    $metricEl = $formEl.parents('.metric')

    new MetricChartView($metricEl, new Metric(data.metric))

  createMetricCharts: ->
    for objective in @objectives
      if objective.metric
        $metricEl = $("#{objective._id}").find('.metric')

        new MetricChartView(
          $metricEl,
          new Metric(objective.metric)
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
