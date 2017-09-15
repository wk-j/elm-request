'use strict';

//require('ace-css/css/ace.css');
//require('font-awesome/css/font-awesome.css');

import("semantic-ui-css/semantic.css");

// Require index.html so it gets copied to dist

var Elm = require('./Main.elm');
var mountNode = document.getElementById("container");
var app = Elm.Main.embed(mountNode);