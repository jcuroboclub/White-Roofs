# @cjsx React.DOM
React = require 'react'
$ = require 'jquery'


thinkspeak = require './thinkspeak'
nv = require './nvwrapper'



ChannelLineGraph = React.createClass

  getInitialState: ->
    title: 'loading'

  componentDidMount: ->
    onInterval = @interval
      svgNode: @refs.visualisation.getDOMNode()
      context: this
      channel: @props.channel
    onInterval()
    setInterval onInterval, 16000

  interval: (config) -> ->
    thinkspeak.get config.channel, 10, (response) ->
      if config.context.state.title != response.channel.name
        config.context.setState { title: response.channel.name }
      nv.drawChart config.svgNode, response, nv.lineChart

  render: ->
    <div className="visualisation">
      <h1>{@state.title}</h1>
      <svg className="chart" ref="visualisation"/>
    </div>



Main = React.createClass

  render: ->
    <div className="container">
      <ChannelLineGraph channel={35686}/>
      <ChannelLineGraph channel={35687}/>
      <ChannelLineGraph channel={35688}/>
    </div>


$(window).ready ->
  React.render <Main />, document.body


