var path = require('path');

module.exports = {
  entry: path.resolve("./index.js"),
  output: {
    path: path.resolve("../static"),
    filename: "app.js"
  },
  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel-loader",
      query: {
        presets: ["es2015", "react"],
      }
    }, {
      test: /\.css$/,
      loaders: ["style-loader", "css-loader?modules"]
    }]
  }
}
