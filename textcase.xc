const $alphabetLower = "abcdefghijklmnopqrstuvwxyzæøå" ; all the lower case letters
const $alphabetUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ" ; all the upper case letters
const $alphabet = $alphabetLower & $alphabetUpper; all lower case in the first half, and the exact same list in upper case in the last half

function @toLower($phrase:text):text ; input $text, a phrase. outputs the phrase in lower case
	var $alphabetSize = size($alphabetLower)
	var $length = size($phrase) ; the number of chars in the phrase
	var $outPhrase = "" ; initializing the phrase that will be returned
	repeat $length ($i) ; loop through the entire text phrase
		var $char = substring($phrase,$i,1) ; get char at current loop position
		var $outChar = $char ; the output character, unchanged if case is correct
		var $loc = find($alphabet,$char) ; check the char number in the alphabet, a==0,A==30-ish 
		if $loc != -1 && $loc >= $alphabetSize ; is the char found in the alphabet, AND is it in the wrong case section?
			$outChar = substring($alphabet,$loc-$alphabetSize,1) ; return the character from the opposite case (29 below current)
		$outPhrase &= $outChar ; add current char to the output phrase
	return $outPhrase ; the finished phrase
		
function @toUpper($phrase:text):text ; input $text, a phrase. outputs the phrase in UPPER case
	var $alphabetSize = size($alphabetLower)
	var $length = size($phrase)
	var $outPhrase = ""
	repeat $length ($i)
		var $char = substring($phrase,$i,1)
		var $outChar = $char
		var $loc = find($alphabet,$char)
		if $loc != -1 && $loc < $alphabetSize ; is the char found in the alphabet, AND is it in the wrong case section?
			$outChar = substring($alphabet,$loc+$alphabetSize,1) ; return the character from the opposite case (29 above current)
		$outPhrase &= $outChar
	return $outPhrase

// EXAMPLE USE --------------------------
// init
//	var $sampleText = "The quick brown Fox jumped OVER the lazy Dog! 123./# UPPER lower"
//	print("Sample text: " & $sampleText)
//	print("To upper case: " & @toUpper($sampleText)
//	print("To lower case: " & @toLower($sampleText)
	
