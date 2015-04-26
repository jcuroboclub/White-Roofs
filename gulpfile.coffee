gulp = require 'gulp'
util = require 'gulp-util'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
mustache = require 'gulp-mustache'
browserify = require 'gulp-browserify'
sourcemaps = require 'gulp-sourcemaps'
livereload = require 'gulp-livereload'


config =
  source:
    main: './app/source/index.coffee'
    files: './app/source/**/*.coffee'
  style:
    main: './app/styles/index.scss'
    files: './app/styles/**/*.scss'
  html:
    files: './app/index.html'
  other:
    outdir: './dist'


gulp.task 'build', ['source-build', 'style-build', 'document-build']


gulp.task 'source-build', ->
  gulp.src(config.source.main, { read: false })
    .pipe sourcemaps.init()
    .pipe browserify
      transform: ['coffeeify']
      extensions: ['.coffee']
    .pipe rename 'index.js'
    .pipe sourcemaps.write()
    .pipe gulp.dest config.other.outdir
    .pipe livereload()
      

gulp.task 'style-build', ->
  gulp.src(config.style.main)
    .pipe sourcemaps.init()
    .pipe sass()
    .pipe sourcemaps.write()
    .pipe gulp.dest config.other.outdir
    .pipe livereload()


gulp.task 'document-build', ->
  gulp.src(config.html.files)
    .pipe mustache
      isProduction: process.env.ENV == 'PROD'
    .pipe gulp.dest config.other.outdir
    .pipe livereload()


gulp.task 'watch', ['build'], ->
  livereload.listen 
    port: 12345
    basePath: config.other.outdir
  gulp.watch config.source.files, ['source-build']
  gulp.watch config.style.files, ['style-build']
  gulp.watch config.html.files, ['document-build']


