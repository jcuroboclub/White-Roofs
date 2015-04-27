# @cjsx React.DOM
React = require 'react'
$ = require 'jquery'


thinkspeak = require './thinkspeak'
nv = require './nvwrapper'



ChannelGraph = React.createClass

  getInitialState: ->
    title: 'loading'

  componentDidMount: ->
    onInterval = @interval
      svgNode: @refs.visualisation.getDOMNode()
      context: this
      channel: @props.channel
      chart: nv.getChart @props.chartType
    onInterval()
    setInterval onInterval, 16000

  interval: (config) -> 
    ->
      thinkspeak.get config.channel, 10, (response) ->
        if config.context.state.title != response.channel.name
          config.context.setState { title: response.channel.name }
        nv.drawChart config.svgNode, response, config.chart 

  render: ->
    <div className="visualisation">
      <h1>{@state.title}</h1>
      <svg className="chart" ref="visualisation"/>
    </div>



Main = React.createClass

  render: ->
    <div className="container">
      <ChannelGraph channel={35686} chartType="historicalBarChart"/>
      <ChannelGraph channel={35687} chartType="historicalBarChart"/>
      <ChannelGraph channel={35688} chartType="lineChart"/>
    </div>


$(window).ready ->
  React.render <Main />, document.body


