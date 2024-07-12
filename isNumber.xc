function @isNumber($textNumber:text):number
	; loops through the text until a disallowed character is found, then return false. If no errors are found, return true
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
; @exampleConvert("ABC",1)
; Example 1
; Number as text : 'ABC'
; Text is a not a number
; 
; Example 2
; @exampleConvert(".123",2)
; Number as text : '.123'
; Text is a number: 0.123
;
; Example 3
; @exampleConvert("0.12.3",3)
; Number as text : '0.12.3'
; Text is a not a number
;
; Example 4
; @exampleConvert("-5",4)
; Number as text : '-5'
; Text is a number: -5
; 
; Example 5
; @exampleConvert("5-",5)
; Number as text : '5-'
; Text is a not a number
	
