# @cjsx React.DOM
React = require 'react'
$ = require 'jquery'
marked = require 'marked'


thinkspeak = require './thinkspeak'
nv = require './nvwrapper'



ChannelGraph = React.createClass

  getInitialState: ->
    title: 'loading'

  componentDidMount: ->
    onInterval = @interval @refs.visualisation.getDOMNode()
    onInterval()
    setInterval onInterval, 16000

  #
  # generates an interval that will be called on each update
  #
  interval: (target) ->
    chart = nv.getChartOfType target, @props.chartType
    return =>
      amount = chart.withinCapacity 200
      thinkspeak.get @props.channel, amount, (response) =>
        if @state.title != response.channel.name
          @setState { title: response.channel.name }
        chart.drawChart response

  render: ->
    <div className="visualisation">
      <h2>{@state.title}</h2>
      <svg className="chart" ref="visualisation"/>
    </div>



Main = React.createClass

  render: ->
    rawMarkup = marked """
                       # White Roofs
                       White Roofs project under development. A joint initiative between [JCU eResearch](https://eresearch.jcu.edu.au), [Townsville City Council](http://www.townsville.qld.gov.au/) and [JCU Robo Club](http://robotics.jcu.io).
                       """
    , {sanitize: true}
    <div className="container">
      <span dangerouslySetInnerHTML={{__html: rawMarkup}} />
      <ChannelGraph channel={35686} chartType="egg"/>
      <ChannelGraph channel={35686} chartType="roofBarChart"/>
      <ChannelGraph channel={35686} chartType="roofLineChart"/>
      <ChannelGraph channel={35687} chartType="roofBarChart"/>
      <ChannelGraph channel={35687} chartType="roofLineChart"/>
      <ChannelGraph channel={35688} chartType="lineChart"/>
    </div>


$(window).ready ->
  React.render <Main />, document.body


