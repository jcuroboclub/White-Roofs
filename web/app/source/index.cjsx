# @cjsx React.DOM
React = require 'react'
$ = require 'jquery'


thinkspeak = require './thinkspeak'
nv = require './nvwrapper'



ChannelGraph = React.createClass

  getInitialState: ->
    title: 'loading'

  componentDidMount: ->
    onInterval = @interval @refs.visualisation.getDOMNode()
    onInterval()
    setInterval onInterval, 16000

  interval: (target) -> 
    chart = nv.getChartOfType target, @props.chartType
    =>
      amount = chart.withinCapacity 100
      thinkspeak.get @props.channel, amount, (response) =>
        console.log response
        if @state.title != response.channel.name
          @setState { title: response.channel.name }
        chart.drawChart response

  render: ->
    <div className="visualisation">
      <h1>{@state.title}</h1>
      <svg className="chart" ref="visualisation"/>
    </div>



Main = React.createClass

  render: ->
    <div className="container">
      <ChannelGraph channel={35686} chartType="roof"/>
      <ChannelGraph channel={35687} chartType="roof"/>
      <ChannelGraph channel={35688} chartType="lineChart"/>
    </div>


$(window).ready ->
  React.render <Main />, document.body


