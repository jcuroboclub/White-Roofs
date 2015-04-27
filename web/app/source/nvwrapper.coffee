d3 = require 'd3'
$ = require 'jquery'
require 'nvd3/build/nv.d3.js'


duration = 1000


parseDateStr = d3.time.format.utc('%Y-%m-%dT%H:%M:%SZ').parse


redraw = (target, chart, data) ->
  d3.select(target).datum(data).call chart


getNvChart = (name) ->
  chart = nv.models[name]()
  chart = chart.useInteractiveGuideline?(true) ? chart
  chart.xAxis.axisLabel('Time').tickFormat (d) -> d3.time.format('%H:%M') new Date(d)
  chart.yAxis.axisLabel('Temp (C)').tickFormat d3.format('.1f')
  nv.utils.windowResize(chart.update)
  return chart


exports.getChartOfType = (target, name) ->
  switch name
    when "roof"
      chart = nv.models['discreteBarChart']()
      chart.xAxis.axisLabel('Roof Color').tickFormat (d) -> d
      chart.yAxis.axisLabel('Temp (C)').tickFormat d3.format('.1f')
      nv.utils.windowResize(chart.update)
      new BarChartDrawer target, chart
    else 
      chart = nv.models[name]()
      if chart.useInteractiveGuideline?
        chart = chart.useInteractiveGuideline(true)
      chart.xAxis.axisLabel('Time').tickFormat (d) -> d3.time.format('%H:%M') new Date(d)
      chart.yAxis.axisLabel('Temp (C)').tickFormat d3.format('.1f')
      nv.utils.windowResize(chart.update)
      new ChartDrawer target, chart



ChartDrawer = class ChartDrawer
  
  withinCapacity: (n) -> n

  __TS_FIELDS: do ((n) -> ('field' + n) for n in [1..8])
  
  constructor: (@target, @chart) ->
    @oldlast = 0

  __structure: (data) ->
    for f in @__TS_FIELDS
      key: data.channel[f]
      values:
        (x: parseDateStr(d.created_at), y: parseFloat(d[f]) for d in data.feeds)

  drawChart: (data) ->
    newdata = @__structure(data)
    console.log newdata
    field1 = newdata[1]
    last = field1.values[field1.values.length-1]
    if last isnt @oldlast # if updated
      @oldlast = last
      data = newdata
      $("#currentInd").text "Current " + field1.key + ": " + last.y.toString()
      redraw @target, @chart, newdata


BarChartDrawer = class BarChartDrawer extends ChartDrawer

  withinCapacity: (n) -> 1

  __structure: (data) ->
    for attribute in super data
      attribute.values[0].x = attribute.key
      attribute




