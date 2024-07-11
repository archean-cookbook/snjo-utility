var $alphabet = "abcdefghijklmnopqrstuvwxyzæøåABCDEFGHIJKLMNOPQRSTUVWXYZÆØÅ" ; all lower case in the first half, and the exact same list in upper case in the last half
var $alphabetSize = 29 ; increase this if you add more characters from your language

function @toLower($text:text):text
	var $length = size($text)
	var $outString = ""
	repeat $length ($i)
		var $char = substring($text,$i,1)
		var $outChar = $char
		var $loc = find($alphabet,$char)
		if $loc != -1 && $loc >= $alphabetSize;; && $loc < size($alphabetSize)
			$outChar = substring($alphabet,$loc-$alphabetSize,1)
		$outString &= $outChar
	return $outString
		
function @toUpper($text:text):text
	var $length = size($text)
	var $outString = ""
	repeat $length ($i)
		var $char = substring($text,$i,1)
		var $outChar = $char
		var $loc = find($alphabet,$char)
		if $loc != -1 && $loc < $alphabetSize
			$outChar = substring($alphabet,$loc+$alphabetSize,1)
		$outString &= $outChar
	return $outString

; example
init
	var $sampleText = "The quick brown Fox jumped OVER the lazy Dog! 123./# UPPER lower"
	print("Sample text: " & $sampleText)
	print("To upper case: " & @toUpper($sampleText)
	print("To lower case: " & @toLower($sampleText)
