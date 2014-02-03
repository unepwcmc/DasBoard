suite("AddObjectiveView")

test("renders a select box for picking a metric", sinon.test(->
  projectId = 5

  view = new AddObjectiveView(projectId)

  metric =
    name: "Total downloads"

  @server.respondWith(
    new RegExp("/metrics/#{projectId}"),
    JSON.stringify([metric])
  )

  @server.respond()

  selects = view.$el.find('select')

  assert.lengthOf selects, 1,
    "Expected there to be a select box"

  assert.match selects.text(), new RegExp(metric.name),
    "Expected to see the metric name in the select"
))
