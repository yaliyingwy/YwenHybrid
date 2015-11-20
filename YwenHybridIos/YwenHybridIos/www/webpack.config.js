'use strict';

var webpack = require('webpack');


var config = {
target: 'web',
cache: true,
entry: {
     app: ['./index.js']
},
resolve: {
root: __dirname,
extensions: ['', '.coffee', '.js'],
modulesDirectories: ['node_modules'],

},
output: {
path: '.',
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