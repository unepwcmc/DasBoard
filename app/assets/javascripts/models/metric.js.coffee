class window.Metric
  constructor: (@attributes) ->

  getDataLabels: ->
    @attributes.data.map( (data_point) ->
      new Date(data_point.date*1000).toDateString()
    )

  getDataPoints: ->
    @attributes.data.map( (data_point) ->
      data_point.value
    )
