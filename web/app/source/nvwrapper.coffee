d3 = require 'd3'
$ = require 'jquery'
require 'nvd3/build/nv.d3.js'


parseDateStr = d3.time.format.utc('%Y-%m-%dT%H:%M:%SZ').parse


getColor = (name) ->
  switch name
    when 'Charcoal' then '#36454f'
    when 'Ultra White' then '#ddd'
    when 'Steel Blue' then '#4682b4'
    when 'White' then '#ccc'
    when 'Creme' then '#FFFFCC'
    when 'Desert Red' then '#B6571D'
    when 'Bone White' then '#E1D4C0'
    when 'Forest Green' then '#228b22'


exports.getChartOfType = (target, name) ->
  switch name
    when "egg"
      new EggChartDrawer target
    when "roofBarChart"
      chart = nv.models['discreteBarChart']()
      chart.showValues true
      chart.x (d) -> d.label
      chart.y (d) -> d.value
      chart.yAxis.axisLabel('Temp (C)')
      chart.xAxis.axisLabel('Roof Color') 
      chart.color (d) -> getColor d.label
      nv.utils.windowResize(chart.update)
      new BarChartDrawer target, chart
    when 'roofLineChart'
      chart = nv.models.lineChart()
      if chart.useInteractiveGuideline?
        chart.useInteractiveGuideline(true)
      chart.xAxis.axisLabel('Time').tickFormat (d) -> d3.time.format('%H:%M') new Date(d)
      chart.yAxis.axisLabel('Temp (C)').tickFormat d3.format('.1f')
      chart.color (d) -> getColor d.key
      nv.utils.windowResize(chart.update)
      new ChartDrawer target, chart
    when 'lineChart'
      chart = nv.models.lineChart()
      if chart.useInteractiveGuideline?
        chart.useInteractiveGuideline(true)
      chart.xAxis.axisLabel('Time').tickFormat (d) -> d3.time.format('%H:%M') new Date(d)
      chart.yAxis.axisLabel('Temp (C)').tickFormat d3.format('.1f')
      nv.utils.windowResize(chart.update)
      new ChartDrawer target, chart


ChartDrawer = class ChartDrawer
  

  redraw: (data) ->
    d3.select(@target).datum(data).call @chart

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
    field1 = newdata[1]
    last = field1.values[field1.values.length-1]
    if last isnt @oldlast # if updated
      @oldlast = last
      @redraw newdata


BarChartDrawer = class BarChartDrawer extends ChartDrawer

  withinCapacity: (n) -> 1

  __structure: (data) ->
    newData = [{ key: 'all', values: []}]
    for attribute in super data
      newData[0].values.push 
        label: attribute.key 
        value: attribute.values[0].y
    return newData

  drawChart: (data) ->
    newdata = @__structure(data)
    console.log newdata
    @redraw newdata


EggChartDrawer = class EggChartDrawer

  constructor: (target) ->
    @svg = d3.select(target)

  __format_layer_2: (data) ->
    for f in @__TS_FIELDS
      key: data.channel[f]
      values:
        (x: parseDateStr(d.created_at), y: parseFloat(d[f]) for d in data.feeds)

  __format_layer_1: (data) ->
    newData = [{ key: 'all', values: []}]
    for attribute in super data
      newData[0].values.push 
        label: attribute.key 
        value: attribute.values[0].y
    return newData

  drawChart: (data) ->
    formatted = @__format_layer_1 data
    @svg.selectAll('circle')
        .data(formatted)
      .enter().append('circle')
        .attr "cx", svg.attr('height') / 2
        .attr "cx", (d, i) ->
          i * (svg.attr('width') / formatted[0].values.length)
        .attr "r", svg.attr('height') / 2 





