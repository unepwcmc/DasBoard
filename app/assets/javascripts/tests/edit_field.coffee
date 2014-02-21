suite('Edit field')

test('.saveUpdate sends a request to the server based on the attributes', ->
  fieldName = 'name'
  url = '/objectives/1'
  modelType = 'objective'

  editedEl = $("""
    <h3 data-field-name="#{fieldName}" data-url="#{url}" data-model-type="#{modelType}">
    New value
    </h3>
  """)

  view = new EditField(editedEl)

  server = sinon.fakeServer.create()
  view.saveUpdate()

  assert.lengthOf server.requests, 1,
    "Expected a request to be sent to the server"

  request = server.requests[0]
  assert.strictEqual request.url, url,
    "Expected the request to be sent to the objective url"

  assert.strictEqual request.method, 'PUT',
    "Expected the request to be sent to the objective url"

  requestBody = JSON.parse(request.requestBody)
  assert.property requestBody, 'objective',
    "Expected the attributes to be nested inside the model name"

  assert.strictEqual $.trim(requestBody['objective'][fieldName]), 'New value',
    "Expected the right value to be sent"
)
