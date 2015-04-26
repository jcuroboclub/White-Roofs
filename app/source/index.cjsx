# @cjsx React.DOM
React = require 'react'
$ = require 'jquery'


Main = React.createClass

  componentDidMount: ->
    console.log 'ayyyyy'

  render: ->
    <div className="container">
      <h1>Hello world</h1>
      <p>ayy <em>lmao</em></p>
    </div>


$(window).ready ->
  React.render <Main />, document.body


