class ReadSvbtle.Views.Index extends Backbone.View
  template: JST['app/scripts/templates/index']

  initialize: =>
    @collection.on 'sync', @render
    @collection.on 'error', @error

    @collection.fetch()

  render: () =>
    @collection.sort()
    @$el.html @template collection: @collection

    @$('.entry').addClass 'animated fadeInRight'
    this

  error: (model, error) =>
    alert "Something's gone horribly wrong. Try again?"
