d3 = require 'd3'
$ = require 'jquery'
require 'nvd3/build/nv.d3.js'


parseDateStr = d3.time.format.utc('%Y-%m-%dT%H:%M:%SZ').parse


__TS_FIELDS = do ((n) -> ('field' + n) for n in [1..8])


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

  constructor: (@target, @chart) ->
    @oldlast = 0

  #
  # withinCapacity basically will take a number of rows,
  # and trim it by the max capacity
  #
  withinCapacity: (n) -> n

  __structure: (data) ->
    for f in __TS_FIELDS
      key: data.channel[f]
      values:
        (x: parseDateStr(d.created_at), y: parseFloat(d[f]) for d in data.feeds)

  drawChart: (data) ->
    newdata = @__structure(data)
    field1 = newdata[1]
    last = field1.values[field1.values.length-1]
    if last isnt @oldlast # if updated
      @oldlast = last
      d3.select(@target).datum(newdata).call @chart


BarChartDrawer = class BarChartDrawer extends ChartDrawer

  #
  # because the bar chart only wants 1 row, it doesn't
  # care about parameters, and just returns 1
  #
  withinCapacity: -> 1

  __structure: (data) ->
    newData = [{ key: 'all', values: []}]
    for attribute in super data
      newData[0].values.push
        label: attribute.key
        value: attribute.values[0].y
    return newData

  drawChart: (data) ->
    newdata = @__structure(data)
    d3.select(@target).datum(newdata).call @chart


EggChartDrawer = class EggChartDrawer

  constructor: (target) ->
    @svg = d3.select(target)

  #
  # because the bar chart only wants 1 row, it doesn't
  # care about parameters, and just returns 1
  #
  withinCapacity: -> 1

  #
  # parse an amount of px's like `250px' to `250'
  #
  __parsePx: (s) ->
    parseInt s.substr(0, s.length - 2), 10

  __structure: (data) ->
    for f in __TS_FIELDS
      label: data.channel[f]
      value: (parseFloat(d[f]) for d in data.feeds)[0]

  drawChart: (data) ->
    @svg.append('text')
      .text 'Would it cook an egg?'
      .attr 'x', 0
      .attr 'y', 20

    @svg.append('text')
        .text "Source: "
        .attr 'x', 0
        .attr 'y', (@__parsePx(@svg.style('height')) - 5)
        .attr 'style', 'font-size:12px'
      .append 'a'
        .text "The Food Lab's Guide to Slow-Cooked, Sous-Vide-Style Eggs"
        .attr "xlink:href"
        , "http://www.seriouseats.com/2013/10/sous-vide-101-all-about-eggs.html"

    formatted = @__structure data

    circle = @svg.selectAll('image').data(formatted)
    text   = @svg.selectAll('#label').data(formatted)

    radius = @__parsePx(@svg.style('height')) / 4.75
    width  = @__parsePx(@svg.style 'width') - radius*3

    circle.enter().append('image')
      .attr "y", (@__parsePx(@svg.style('height')) / 2) - (radius * 1.25)
      .attr "x", (d, i) =>
        (radius*1.5 + (i * (width / (formatted.length-1)))) - radius
      .attr "width", radius * 2
      .attr "height", radius * 2
      .attr "xlink:href", (d) ->
        #
        # eggcellent
        #
        switch
          when d.value > 73.9 then './img/egg1.png'
          when d.value > 71.1 then './img/egg2.png'
          when d.value > 68.3 then './img/egg3.png'
          when d.value > 65.6 then './img/egg4.png'
          when d.value > 62.8 then './img/egg5.png'
          when d.value > 60.0 then './img/egg6.png'
          when d.value > 57.2 then './img/egg7.png'
          else                     './img/egg8.png'


    text.enter().append('text')
      .attr 'class', 'label'
      .attr "y", @__parsePx(@svg.style('height')) * 0.8
      .attr "x", (d, i) =>
        radius * 1.5 + (i * (width / (formatted.length-1)))
      .attr("text-anchor", 'middle')
      .text (d) -> d.label

    circle.exit().remove()





