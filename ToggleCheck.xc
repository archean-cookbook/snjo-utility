; Allows the user to press a key from a seat, turning on or off a value. Won't get flipped endlessly if the button is held
; This code assumes that the seat is NOT set to smooth controls. If so, some small rewrite is needed.
; With an example of use in a headlight setup

function @toggleCheck($object:text,$seatchannel:number):text
	$object.newclick = input_number("seat",$seatchannel)
	if $object.newclick == 1 && $object.newclick != $object.oldclick
		$object.on = !$object.on
		;print("toggle",$object.on)
	$object.oldclick = $object.newclick
	return $object

; define toggle values, as global variables at the top of the file
; var $headlight = ""

; Set them up in init (optional since 0 values are fine)
;
; init
;	$headlight.on = 0 ; set starting value, if not set, defaults to off (0)
;	$headlight.brightness = 100 ; not part of the toggle check, but a value defined by you for whatever

; update each tick or update, toggles if the user has pressed a corresponding button from the seat
;
; tick
;	$headlight = @toggleCheck($headlight,9)  ; lights toggled if user pressed seat channel 9, (number key 2)



; example of referencing the toggle value
; in e.g. tick or update
;
; update
;	if $headlight.on
;		@setLight("headlight",$headlight.on,$headlight.brightness)
