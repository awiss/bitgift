var codes = {
    1: ['373X-GE4EB8-KHZZ', '59JH-3YDAFS-54YM', '7CUJ-MLL89T-FXA6', 'CLF3-Q9M4R6-58TV', 'DZS9-EH4SD3-E835'],
    2: ['LCLQ-SM6E8D-Z7L8', 'V8YC-T6ULKL-98HD'],
    4: ['AFE9-WY9N8Y-2WKW']
}


module.exports = function(priceInCents) {
	var totalDollars = priceInCents / 100;
	totalDollars += priceInCents % 100 ? 1 : 0;
	var curr = totalDollars;
	var bitString = '';
	while (curr > 0) {
		var bit = curr % 2;
		bitString = '' + bit + bitString;
		curr = Math.floor(curr/2);
	}
	var returnCodes;
	for (var i = 0; i < bitString.length; i++) {
		if (bitString === '1') {
			returnCodes.push.apply(returnCodes,(codes[2^i].splice(0,1)));
		}
	}
	return returnCodes;
}
