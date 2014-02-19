window.DasBoard ||= {}

window.DasBoard.addObjective = (event) ->
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
