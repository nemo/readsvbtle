class ReadSvbtle.Collections.Entries extends Backbone.Collection
  url: '/getfeed'
  model: ReadSvbtle.Models.Entry

  comparator: (model1, model2) =>
    time1 = new Date(model1.get('date')).getTime()
    time2 = new Date(model2.get('date')).getTime()

    if time1 > time2
      -1
    else if time1 < time2
      1
    else
      0
