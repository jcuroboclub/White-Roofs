$ = require 'jquery'

THINK_SPEAK_URL = 'https://api.thingspeak.com'


exports.get = (channel, results, callback) ->
  url = "#{THINK_SPEAK_URL}/channels/#{channel}/feed.json?results=#{results}"
  $.getJSON url, callback
