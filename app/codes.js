var fs = require('fs');
var exec = require('child_process').exec;

exports.getCodes = function(priceInCents, site, test) {
	try {
		var codes = JSON.parse(fs.readFileSync('./'+site+'codes.json', 'utf-8'));
	} catch (err) {
		console.log(err);
		return; 
	}
	
	var totalDollars = Math.ceil(priceInCents / 100);
	var curr = totalDollars;
	var bitString = [];
	while (curr > 0) {
		var bit = curr % 2;
		bitString.push(bit);
		curr = Math.floor(curr/2);
	}
	var dollarVals = [];
	var returnCodes = [];
	for (var i = bitString.length-1; i > -1; i--) {
		if (bitString[i]) {
			var pow = Math.pow(2,i).toString();
			codes[pow] = codes[pow] || [];
			arr = codes[pow].splice(0, bitString[i]);
			var diff = bitString[i] - arr.length;
			if (i === 0 && diff) {
				return [];
			}
			bitString[i-1] += diff*2;
			for (var j = 0; j < arr.length; j++) {
				dollarVals.push(pow);
			}
			returnCodes.push.apply(returnCodes, arr);		
		}
	}
	var call = 'ruby ../scripts/buy_gift_cards.rb';
	for(var i = 0; i < dollarVals.length; i++) {
		call += ' "'+dollarVals[i]+'"';
	}
	console.log(call);
	if (!test) {
		fs.writeFileSync('./'+site+'codes.json', JSON.stringify(codes));
		var child = exec(call, function(error, stdout, stderror) {
			console.log(stdout);
			//exports.addCodes(stdout);
		});
		
	}
	return returnCodes;
}

exports.addCodes = function(newCodes, site) {
	try {
		var codes = JSON.parse(fs.readFileSync('./'+site+'codes.json', 'utf-8'));
	} catch (err) {
		var codes = {};
	}
	for (num in newCodes) {
		if (Math.log(num)/Math.LN2 % 1 !== 0) {
			console.log('Error: Cards must be in powers of two');
			return;
		}
		if (codes[num]) {
			codes[num].push.apply(codes[num], newCodes[num]);
		} else {
			codes[num] = newCodes[num];
		}
	}
	fs.writeFileSync('./'+site+'codes.json', JSON.stringify(codes));
	return;
}


