promise = require 'promise'

class View
  constructor: (config) ->
    @_rows = []
    @_idx = 0
    datasetId = config['cats.dataset.id']
    if not not datasetId
      window.Cortex.app.onData datasetId, @_onData

  prepare: (offer) =>
    if not @_rows? or @_rows.length == 0
      return offer()

    if @_idx >= @_rows.length
      @_idx = 0

    row = @_rows[@_idx]
    @_createDOMNode row
      .then (node) ->
        container = document.getElementById('container')
        offer (done) ->
          while container.firstChild?
            container.removeChild container.firstChild
          container.appendChild node
          setTimeout done, row.duration
      .catch (e) ->
        console.error "Failed to create DOM node.", e
        offer()

    @_idx += 1

  _createDOMNode: (row) ->
    new promise (resolve, reject) ->
      opts =
        cache:
          mode: 'normal'
          ttl:  7 * 24 * 60 * 60 * 1000

      window.Cortex.net.get row?.url, opts
        .then ->
          img = new Image()
          img.onload = ->
            resolve img
          img.onerror = reject
          img.src = row.url
        .catch reject

  _onData: (rows) =>
    @_rows = rows

module.exports = View
