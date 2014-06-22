var express = require('express');
var router = express.Router();

/* POST */
router.post('/coinbase', function(req, res) {
  console.log(req.body);
  res.end();
});

module.exports = router;