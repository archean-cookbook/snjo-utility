; example of calling one of the methods below
#	@drawBattery($screen,$battCharge, $battX, $battY, $battW, $battH, "Left") ; draws to the first screen on the dash
#	@drawTriangle($screen,10,50,30,green) ; draws to the second screen on the dash
; or you can access them via dot extension, so instead of naming the screen as an argument, you can flip it around for a cleaner look:
#	$screen.@drawTriangle(10,50,30,green)
; note that this method is not valid in assignments, and the system will inform you of this. In that case, use the first method.

; standalone/static methods, can be put in separate file

function @drawTriangle($screen:screen,$X:number,$Y:number,$size:number,$color:number)
	$screen.draw_triangle($X+$size/2,$Y, $X,$Y+$size, $X+$size,$Y+$size,$color)

function @drawBattery($screen:screen, $charge:number, $X:number, $Y:number, $W:number, $H:number, $text:text)
	$screen.draw_rect($X-3,$Y+4,$X+1,$Y+$H-4,white,gray) ; nub
	$screen.draw_rect($X,$Y,$X+$W,$Y+$H,white,black) ; main battery body
	if $charge > 0 && $charge < 0.06 ;smallest visible blue section if almost depleted
		$charge = 0.07
	if $charge > 0.06
		var $chargeW = $W * $charge
		$screen.draw_rect($X+1,$Y+1,$X+$chargeW-1,$Y+$H-1,0,blue) ; draw charge
	else
		$screen.draw_rect($X+1,$Y+1,$X+$W-1,$Y+$H-1,0,red) ; battery empty, draw red
	if size($text) > 0
		$screen.write($X+5,$Y+(($H-$screen.char_h)/2),white,$text)
		
function @drawRoundedRectangle($screen:screen,$X:number,$Y:number,$width:number,$height:number,$radius:number,$lineColor:number,$fillColor:number)
	;example @drawRoundedRectangle(10,10,80,50,10,cyan,blue)
	var $right = $X + $width
	var $bottom = $Y + $height
	$screen.draw_circle($X+$radius-1,$Y+$radius-1,$radius,$lineColor,$fillColor)
	$screen.draw_circle($right-$radius,$Y+$radius-1,$radius,$lineColor,$fillColor)
	$screen.draw_circle($X+$radius-1,$bottom-$radius,$radius,$lineColor,$fillColor)
	$screen.draw_circle($right-$radius,$bottom-$radius,$radius,$lineColor,$fillColor)
	$screen.draw_rect($X+$radius, $Y, $right-$radius, $bottom,0,$fillColor)
	$screen.draw_rect($X,$Y+$radius,$right,$bottom-$radius,0,$fillColor)
	$screen.draw_line($X+$radius, $Y, $right-$radius, $Y,$lineColor)
	$screen.draw_line($X+$radius, $bottom, $right-$radius, $bottom,$lineColor)
	$screen.draw_line($X, $Y+$radius, $X, $bottom-$radius,$lineColor)
	$screen.draw_line($right, $Y+$radius, $right, $bottom-$radius,$lineColor)
	
function @drawSpeechBubble($screen:screen,$X:number,$Y:number,$width:number,$height:number,$radius:number,$lineColor:number,$fillColor:number,$tailWidth:number,$tailLength:number)
	var $right = $X + $width
	var $bottom = $Y + $height
	if $tailLength == 0
		$tailLength = $height/2
	if $tailWidth == 0
		$tailWidth = $radius
	@drawRoundedRectangle($screen,$X,$Y,$width,$height,$radius,$lineColor,$fillColor)
	$screen.draw_triangle($X+$radius,$bottom-1, $X+$radius+$tailWidth,$bottom-1, $X+$radius/2,$bottom+$tailLength,0,$fillColor)
	$screen.draw_line($X+$radius,$bottom-1,$X+$radius/2,$bottom+$tailLength,$lineColor)
	$screen.draw_line($X+$radius+$tailWidth,$bottom,$X+$radius/2,$bottom+$tailLength,$lineColor)
	
function @drawHome($screen:screen,$X:number,$Y:number,$size:number,$fillColor:number)
	var $left = $X-1 ; fixes not matching the surrounding box
	var $right = $X + $size
	var $bottom = $Y + $size
	var $houseChunk = $size/10
	var $roofline = $Y+$size/2
	;$screen.draw_rect($X,$Y,$right,$bottom,red,0) ; box outline
	$screen.draw_rect($left+$houseChunk*2,$roofline,$X+$houseChunk*4,$bottom,0,$fillColor)
	$screen.draw_rect($left+$houseChunk*3,$roofline,$X+$houseChunk*7,$roofline+$houseChunk*2,0,$fillColor)
	$screen.draw_rect($left+$houseChunk*6,$roofline,$X+$houseChunk*8,$bottom,0,$fillColor)
	$screen.draw_triangle($left,$roofline,$right,$roofline,$X+$size/2,$Y,0,white)
	
function @drawHomeButton($screen:screen,$X:number,$Y:number,$size:number,$fillColor:number):number
	$screen.@drawHome($X,$Y,$size,$fillColor)
	return  $screen.button_rect($X,$Y,$X+$size,$Y+$size,0,0)
	
function @drawChippy($screen:screen,$cx:number,$cy:number)
	; draw Chippy, a horryfing mascot assistant
	;var $cx = 10
	;var $cy = 100
	var $culx = $cx
	var $culy = $cy
	var $curx = $cx+40
	var $cury = $cy-5
	var $cblx = $cx+2
	var $cbly = $cy+60
	var $cbrx = $cx+42
	var $cbry = $cy+57
	var $chippyColor = color(20,50,20)
	var $chippyCopper = color(80,50,0)
	var $lineDist = 5
	$screen.draw_triangle($culx,$culy, $curx,$cury, $cblx,$cbly,0,$chippyColor)
	$screen.draw_triangle($cbrx,$cbry, $curx,$cury, $cblx,$cbly,0,$chippyColor)
	$screen.draw_line($culx,$culy,$curx,$cury,black)
	$screen.draw_line($curx,$cury,$cbrx,$cbry,black)
	$screen.draw_line($cbrx,$cbry,$cblx,$cbly,black)
	$screen.draw_line($cblx,$cbly,$culx,$culy,black)
	$screen.draw_line($culx+$lineDist,$culy+$lineDist, $cblx+$lineDist,$cbry-$lineDist,$chippyCopper)
	$screen.draw_line($curx-$lineDist,$cury+$lineDist, $cbrx-$lineDist-1,$cbry-$lineDist*4,$chippyCopper)
	$screen.draw_line($curx-$lineDist,$cury+$lineDist*8, $cbrx-$lineDist*6-1,$cbry-$lineDist*4,$chippyCopper)
	$screen.draw_line($culx-$lineDist+20,$culy+$lineDist+10, $cblx+$lineDist+10,$cbly-$lineDist-4,$chippyCopper)
	$screen.draw_line($culx+$lineDist+2,$culy+$lineDist+20, $culx+$lineDist+25,$culy+$lineDist+18,$chippyCopper)
	$screen.draw_circle($culx+12,$culy+10,8,black,white)
	$screen.draw_circle($culx+38,$culy+12,8,black,white)
	$screen.draw_circle($culx+12,$culy+12,4,black,red)
	$screen.draw_circle($culx+40,$culy+12,4,black,red)
	$screen.draw_triangle($cblx+5,$cbly-1,$cblx+5,$cbly+20,$cblx+15,$cbly-1,black,color(10,30,10))
	$screen.draw_triangle($cblx+26,$cbly-3,$cblx+27,$cbly+20,$cblx+35,$cbly-3,black,color(10,30,10))
	; end Chippy, please!
			