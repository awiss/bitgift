var express = require('express');
var router = express.Router();
var request = require('request')

/* GET */
router.get('/', function(req, res) {
  var code = req.query.code;

  var client_id = process.env.COINBASE_CLIENT_ID;
  var client_secret = process.env.COINBASE_CLIENT_SECRET;
  var redirect_uri = 'http://localhost:2000/coinbase'

  var url = 'https://coinbase.com/oauth/token?grant_type=authorization_code&code=' + code + "&redirect_uri=" + redirect_uri + "&client_id=" + client_id + "&client_secret=" + client_secret;

  console.log(url);

  request.post(url, function(error, response, body){
    var access_token = JSON.parse(body).access_token;
    var response = "<!DOCTYPE html><html><head><script>window.postMessage('" + access_token + "');</script></head><body>" + access_token + "</body></html>";
    res.send(response);
  });
});

module.exports = router;
