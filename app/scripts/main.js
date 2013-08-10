/*global readsvbtle, $*/


window.ReadSvbtle = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    init: function () {
      new ReadSvbtle.Routers.IndexRouter()

      Backbone.history.start()
    }
};

/* Order and include as you please. */
require('.tmp/scripts/templates');

/* For JS versions */
require('app/scripts/views/**/*');
require('app/scripts/models/*');
require('app/scripts/collections/*');
require('app/scripts/controllers/*');
require('app/scripts/routers/*');

/* For Coffee versions */
require('.tmp/scripts/views/**/*');
require('.tmp/scripts/controllers/*');
require('.tmp/scripts/models/*');
require('.tmp/scripts/collections/*');
require('.tmp/scripts/routers/*');

$(document).ready(function () {
    ReadSvbtle.init();
});
