gulp = require 'gulp'
plugins = require('gulp-load-plugins')()


#webpack
webpack = require 'webpack'
config = require './webpack.config.js'

gulp.task 'webpack:build', (cb)->
	myConfig = Object.create config
	myConfig.output.publicPath = './'
	myConfig.plugins = myConfig.plugins.concat(
		new webpack.DefinePlugin({
			'process.env': {
				'NODE_ENV': JSON.stringify 'production'
			}
		}),
		new webpack.optimize.DedupePlugin(),
		new webpack.optimize.UglifyJsPlugin {
			compress: {
				drop_console: false
			}
			outSourceMap: false
		}
	) 
	webpack myConfig, (err, stats)->
			plugins.util.PluginError 'webpack', err  if err
			plugins.util.log '[webpack]', stats.toString {colors: true}
			cb()

gulp.task 'dist', ['webpack:build'], ->
	gulp.src('www/*').pipe(gulp.dest('YwenHybridIos/YwenHybridIos/www')).pipe(gulp.dest('YwenHybridAndroid/app/src/main/assets/www'))

gulp.task 'default', ['dist']
