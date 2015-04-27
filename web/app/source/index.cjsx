# @cjsx React.DOM
React = require 'react'
$ = require 'jquery'


thinkspeak = require './thinkspeak'
nv = require './nvwrapper'


Main = React.createClass

  getInitialState: ->
    title: 'Loading'

  componentDidMount: ->
    onInterval = @interval
      svgNode: @refs.visualisation.getDOMNode()
      context: this
    onInterval()
    setInterval onInterval, 16000

  interval: (config) -> ->
    thinkspeak.get 35686, 10, (response) ->
      if config.context.state.title != response.channel.name
        config.context.setState { title: response.channel.name }
      nv.drawChart config.svgNode, response, nv.lineChart

  render: ->
    <div className="container">
      <h1>{@state.title}</h1>
      <svg className="chart" ref="visualisation"/>
    </div>


$(window).ready ->
  React.render <Main />, document.body


