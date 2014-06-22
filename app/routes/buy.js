var express = require('express');
var router = express.Router();
var request = require('request')
var codes = require('../codes.js')
var querystring = require('querystring')

function toAmount(amount){
  amount = Number(amount);
  if (isNaN(amount)){
      throw 'invalid: can\'t convert input';
    }
  return (amount/100).toFixed(2);
}

router.post('/', function(req, res) {
  var tokens = req.body.tokens;
  var amount = req.body.amount; // in cents
  var site = req.body.site;
  var code_arr = codes.getCodes(amount, site);

  if (code_arr.length < 0){
    res.send('fucked up shit');
    return;
  }

  var post_data = {
    'transaction': {
      'access_token': tokens.access_token,
      'to': 'nicholasmeyer@gmail.com',
      'amount_string': ".01", // toAmount(Math.ceil(amount/100)*100),
      'amount_currency_iso': 'USD'
    }
  };

  console.log(post_data);
  console.log(tokens.access_token);

  request.post('https://coinbase.com/api/v1/transactions/send_money?access_token=' + tokens.access_token, {form:post_data}, function(error, response, body){
    if (response.statusCode == 200){
      res.json({codes: code_arr, tokens:tokens});
    }
    else if (response.statusCode == 401){
      var client_id = process.env.COINBASE_CLIENT_ID;
      var client_secret = process.env.COINBASE_CLIENT_SECRET;
      var redirect_uri = 'http://localhost:2000/coinbase'

      var url = 'https://coinbase.com/oauth/token?grant_type=refresh_token&code=' + tokens.code + "&redirect_uri=" + redirect_uri + "&client_id=" + client_id + "&client_secret=" + client_secret + "&refresh_token=" + tokens.refresh_token;
      request.post(url, function(error, response, body){
        if (response.statusCode == 200){
          tokens.access_token = JSON.parse(body).access_token;
          tokens.refresh_token = JSON.parse(body).refresh_token;
            request.post('https://coinbase.com/api/v1/transactions/send_money?access_token=' + tokens.access_token, {form:post_data}, function(error, response, body){
              res.json({codes: code_arr, tokens:tokens});
            });
        }
        else {
          res.send('error');
        }
      });
    }
    else {
      res.send('error');
    }
  });
});

module.exports = router;
