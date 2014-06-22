var express = require('express');
var path = require('path');
var favicon = require('static-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var codes = require('./codes.js')

var routes = require('./routes/index');
var users = require('./routes/users');
var coinbase = require('./routes/coinbase');

var app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
dotenv = require('dotenv');
dotenv.load();

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
app.use('/coinbase', coinbase);
app.use('/users', users);

/// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

module.exports = app;
