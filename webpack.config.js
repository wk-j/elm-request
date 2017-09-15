var CopyWebpackPlugin =  require("copy-webpack-plugin");

module.exports = {
    entry: 
    {
        main: "./src/Main.js"
    },
    output: {
        path: __dirname + "/dist",
        filename: "[name].js"
    },
    module: {
      loaders: [
        { test:    /\.elm$/, exclude: [/elm-stuff/, /node_modules/], loader: "elm-webpack-loader?verbose=true&warn=true" },
        { enforce: "pre", test: /\.js$/, loader: "source-map-loader" },
        { test: /\.(eot|woff|woff2|svg|ttf|png)([\?]?.*)$/, loader: "file-loader" },
        { test: /\.css$/, loader: "style-loader!css-loader" }
      ]
    },
    plugins: [
        new CopyWebpackPlugin([{
            from: "src/Index.html",
            to : "Index.html"
        }])
    ],
  };