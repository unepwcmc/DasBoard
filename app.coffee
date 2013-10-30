express = require 'express'
http = require 'http'

PORT = 3001

startApp = ->
  app = express()

  app.get "/", (req, res) ->
    res.send(200, 'Sup yo')

  server = http.createServer(app).listen PORT, (err) ->
    if err
      console.error err
      process.exit 1
    else
      console.log "Express server listening on port " + PORT

startApp()
