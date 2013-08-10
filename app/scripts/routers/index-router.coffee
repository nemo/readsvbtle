class ReadSvbtle.Routers.IndexRouter extends Backbone.Router

  routes:
    '': 'index'

  index: =>
    entries = new ReadSvbtle.Collections.Entries()
    view = new ReadSvbtle.Views.Index(collection: entries)

    $('#body').html view.render().el
