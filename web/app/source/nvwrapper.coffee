d3 = require 'd3'
$ = require 'jquery'
require 'nvd3/build/nv.d3.js'


TS_FIELDS = do ((n) -> ('field' + n) for n in [1..8])


duration = 1000


parseDateStr = d3.time.format.utc('%Y-%m-%dT%H:%M:%SZ').parse


redraw = (target, chart, data) ->
  d3.select(target).datum(data).call chart


exports.getChart = (name) ->
  console.log name
  console.log nv.models
  chart = nv.models[name]()
  chart = chart.useInteractiveGuideline?(true) ? chart
  chart.xAxis.axisLabel('Time').tickFormat (d) -> d3.time.format('%H:%M') new Date(d)
  chart.yAxis.axisLabel('Temp (C)').tickFormat d3.format('.1f')
  nv.utils.windowResize(chart.update)
  return chart





toNv = (tsData) ->
  for f in TS_FIELDS
    key: (tsData.channel[f])
    values:
      (x: parseDateStr(d.created_at), y: parseFloat(d[f]) for d in tsData.feeds)


oldlast = 0


exports.drawChart = (target, newdata, chart) ->
  newdata = toNv(newdata)
  field1 = newdata[1]
  last = field1.values[field1.values.length-1]
  if last isnt oldlast # if updated
    oldlast = last
    data = newdata
    $("#currentInd").text "Current " + field1.key + ": " + last.y.toString()
    redraw target, chart, newdata


exports.showCurrent




