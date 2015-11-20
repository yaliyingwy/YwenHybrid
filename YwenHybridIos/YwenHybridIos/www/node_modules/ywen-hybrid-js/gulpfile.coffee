gulp = require 'gulp'
plugins = require('gulp-load-plugins')()

gulp.task 'build', ->
	gulp.src('src/*.coffee').pipe(plugins.coffee()).pipe(gulp.dest('build'))

gulp.task 'test', ->
	gulp.src('test/*.coffee').pipe(plugins.coffee()).pipe(gulp.dest('test')).pipe(plugins.mocha())

gulp.task 'default', ['build']