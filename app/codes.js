var fs = require('fs');

function clone(obj) {
	var _new = {};
	for(x in obj){
		_new[x] = obj[x];
	}
	return _new;
}

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
			returnCodes.push.apply(returnCodes, arr);		
		}
	}
	if (!test) {
		fs.writeFileSync('./'+site+'codes.json', JSON.stringify(codes));
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

