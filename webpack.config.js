'use strict';

var webpack = require('webpack');


var config = {
target: 'web',
cache: true,
entry: {
     app: ['www/index.js']
},
resolve: {
root: __dirname,
extensions: ['', '.coffee', '.js'],
modulesDirectories: ['node_modules'],

},
output: {
path: 'www',
publicPath: '/',
filename: '[name].js',
    // library: ['Example', '[name]'],
pathInfo: true
},
    
module: {
loaders: []
},
plugins: [
          new webpack.NoErrorsPlugin(),
          ],
};



module.exports = config;
