class ReadSvbtle.Views.Index extends Backbone.View
  template: JST['app/scripts/templates/index']

  tagName: 'ul'
  className: 'entries'

  initialize: =>
    @collection.on 'sync', @render
    @collection.on 'error', @error

    @collection.fetch()

  render: () =>
    @collection.sort()
    @$el.html @template collection: @collection

    if @collection.models.length == 0
      @spinner().spin @$('#spin')[0]
    else
      @$('#spin').html ""

    @$('.entry').addClass 'animated fadeInRight'
    this

  error: (model, error) =>
    alert "Something's gone horribly wrong. Try again?"

  spinner: =>
    opts = {
      lines: 13, # The number of lines to draw
      length: 8 # The length of each line
      width: 3, # The line thickness
      radius: 5, # The radius of the inner circle
      corners: 1, # Corner roundness (0..1)
      rotate: 5, # The rotation offset
      direction: 1, # 1: clockwise, -1: counterclockwise
      color: '#000', # #rgb or #rrggbb
      speed: 1, # Rounds per second
      trail: 60, # Afterglow percentage
      shadow: false, # Whether to render a shadow
      hwaccel: false, # Whether to use hardware acceleration
      className: 'spinner', # The CSS class to assign to the spinner
      zIndex: 2e9, # The z-index (defaults to 2000000000)
      top: 'auto', # Top position relative to parent in px
      left: 'auto' # Left position relative to parent in px
    }

    new Spinner(opts)
