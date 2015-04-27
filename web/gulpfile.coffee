gulp = require 'gulp'
util = require 'gulp-util'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
mustache = require 'gulp-mustache'
browserify = require 'gulp-browserify'
sourcemaps = require 'gulp-sourcemaps'
livereload = require 'gulp-livereload'
ghPages = require 'gulp-gh-pages'


config =
  source:
    main: './app/source/index.cjsx'
    files: './app/source/**/*.{coffee,cjsx}'
  style:
    main: './app/styles/index.scss'
    files: './app/styles/**/*.scss'
  image:
    files: './app/img/**/*.png'
  html:
    files: './app/index.html'
  other:
    outdir: './dist'


gulp.task 'build', ['source-build', 'style-build', 'document-build', 'image-build']


gulp.task 'source-build', ->
  gulp.src(config.source.main, { read: false })
    .pipe browserify
      transform: ['coffee-reactify']
      extensions: ['.coffee', '.cjsx']
    .on 'error', util.log
    .pipe rename 'index.js'
    .pipe gulp.dest "#{config.other.outdir}/js"
    .pipe livereload()


gulp.task 'style-build', ->
  gulp.src(config.style.main)
    .pipe sourcemaps.init()
    .pipe sass()
    .on 'error', util.log
    .pipe sourcemaps.write('.')
    .pipe gulp.dest "#{config.other.outdir}/css"
    .pipe livereload()


gulp.task 'image-build', ->
  gulp.src(config.image.files)
    .pipe gulp.dest "#{config.other.outdir}/img"
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
  gulp.watch config.image.files, ['image-build']
  gulp.watch config.html.files, ['document-build']

gulp.task 'deploy', ['build'], ->
  gulp.src "#{config.other.outdir}/**/*"
    .pipe(ghPages());
