View = require './view'

init = ->
  window.addEventListener 'cortex-ready', ->
    window.Cortex.app.getConfig()
      .then (config) ->
        window.CortexView = new View config
        window.Cortex.scheduler.onPrepare window.CortexView.prepare

      .catch (e) ->
        console.error 'Failed to initialize the application.', e
        throw e

module.exports = init()
