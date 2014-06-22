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

router.get('/', function(req, res) {
  var access_token = req.query.access_token;
  var amount = parseInt(req.query.amount); // in cents
  var code_arr = codes.getCodes(amount);

  if (code_arr.length < 0){
    res.send('fucked up shit');
    return;
  }

  var post_data = {
    'transaction': {
      'access_token': access_token,
      'to': 'nicholasmeyer@gmail.com',
      'amount_string': toAmount(amount),
      'amount_currency_iso': 'USD'
    }
  };

  console.log(post_data)

  request.post('https://coinbase.com/api/v1/transactions/send_money?access_token=' + access_token, {form:post_data}, function(error, response, body){
    if (response.statusCode == 200){
      res.send(JSON.stringify(code_arr));
    }
    else {
      res.send(body);
    }
  });
});

module.exports = router;
