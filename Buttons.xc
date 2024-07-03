; Button, no screen config agument

function @button($screen:screen, $x:number, $y:number,  $text:text, $width:number, $height:number, $linecolor:number, $fillcolor:number, $textcolor:number, $padding:number):number
	if $padding == -1 ; user set no padding. Previous default value detected, setting real default of 5
		$padding = 5
	;automatically set width and height based on text length if they are not specified in the arguments (value is 0)
	if $width == 0
		$width = size($text)*$screen.char_w + $padding*2
	if $height == 0
		$height = $screen.char_h + $padding*2
	; draw and check for click
	var $result = $screen.button_rect($x,$y,$x+$width,$y+$height,$linecolor,$fillcolor)
	; add the text on the button
	$screen.write($X+$padding,$Y+$padding,$textcolor,$text)
	
	; reset the default values (because of a design quirk in xenon)
	; https://wiki.archean.space/xenoncode/documentation.html > search for "Omitted arguments"
	$width = 0
	$height = 0
	$linecolor = cyan
	$fillcolor = blue
	$textcolor = white
	$padding = -1 ; sets it to an invalid state, so if no padding value is passed as argument, resets to 5 next go around. Still allows for a call of 0 if the user inputs that
	return $result