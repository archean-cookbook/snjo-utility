
function @isNumber($textNumber:text):number
	// loops through the text until a disallowed character is found, then return false. If no errors are found, return true

	var $textLength = size($textNumber)
	// Accepts values of zero length as 0, and no limit to upper length. Add checks for that if needed:
	// if $textLength < 1 || $textLenght > 50	; 50 digits shouldn't be possible in 64-big floating point... right?
	// 	return false ; not a number, too small or too large

	var $allowed = "0123456789.-"
	var $textLength = size($textNumber)
	var $numDot = 0 ; counts if more than one decimal point exists, indicating NaN
	repeat $textLength ($i)
		var $char = substring($textNumber,$i,1)
		if $char == "."
			$numDot++
		if $numDot > 1
			; not a number. Found multiple decimal points
			return 0
		if $char == "-" && $i > 0
			; not a number. Found minus after first char
			return 0
		if find($allowed,$char) == -1
			; not a number. Found disallowed char
			return 0
	; no disallowed chars, return true
	return 1

; ------------------ EXAMPLES BELOW, not needed in your code --------------------------

function @exampleConvert($textExample:text,$exampleNumber:number)
	print("")
	print(text("Example {}",$exampleNumber)
	print(text("Number as text : '{}'",$textExample)
	if @isNumber($textExample):text
		var $conv = $textExample:number
		print(text("Text is a number: {}",$conv)
	else
		print("Text is a not a number")

; Test Output
;
; Example 1, plain text
; @exampleConvert("ABC",1)
; Number as text : 'ABC'
; Text is a not a number
; 
; Example 2, decimal point number
; @exampleConvert(".123",2)
; Number as text : '.123'
; Text is a number: 0.123
;
; Example 3, too many decimal points
; @exampleConvert("0.12.3",3)
; Number as text : '0.12.3'
; Text is a not a number
;
; Example 4, leading minus
; @exampleConvert("-5",4)
; Number as text : '-5'
; Text is a number: -5
; 
; Example 5, minus in wrong place
; @exampleConvert("5-",5)
; Number as text : '5-'
; Text is a not a number
;
; Example 6, zero length text
; @exampleConvert("",6)
; Number as text : ''
; Text is a number: 0
	
