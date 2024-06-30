; Button, no screen config agument

function @button($x:number, $y:number, $width:number, $height:number, $linecolor:number, $backcolor:number, $text:text, $textcolor:number, $margin:number):number
	var $screen = screen ; change this to fit your code
  	;automatically set width and height if they are not specified in the arguments (value is 0)
	if $width == 0
		$width = size($text)*$screen.char_w + $margin*2
	if $height == 0
		$height = $screen.char_h + $margin*2
	; draw and check for click
	var $result = $screen.button_rect($x,$y,$x+$width,$y+$height,$linecolor,$backcolor)
 	; add the text on the button
	$screen.write($X+$margin,$Y+$margin,$textcolor,$text)
	return $result


; Same thing, but using the $dashCfg style used in shapes.xc

function @button($dashCfg:text,$x:number, $y:number, $width:number, $height:number, $linecolor:number, $backcolor:number, $text:text, $textcolor:number, $margin:number):number
	var $screen = screen($dashCfg.dashName,$dashCfg.screen:number)
	;automatically set width and height if they are not specified in the arguments (value is 0)
	if $width == 0
		$width = size($text)*$screen.char_w + $margin*2
	if $height == 0
		$height = $screen.char_h + $margin*2
	; draw and check for click
	var $result = $screen.button_rect($x,$y,$x+$width,$y+$height,$linecolor,$backcolor)
	; add the text on the button
	$screen.write($X+$margin,$Y+$margin,$textcolor,$text)
	return $result
