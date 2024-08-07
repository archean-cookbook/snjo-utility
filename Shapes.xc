; example of calling one of the methods below
#	@drawBattery($screen,$battCharge, $battX, $battY, $battW, $battH, "Left") ; draws to the first screen on the dash
#	@drawTriangle($screen,10,50,30,green) ; draws to the second screen on the dash
; or you can access them via dot extension, so instead of naming the screen as an argument, you can flip it around for a cleaner look:
#	$screen.@drawTriangle(10,50,30,green)
; note that this method is not valid in assignments, and the system will inform you of this. In that case, use the first method.


function @drawTriangleUp($_screen:screen,$X:number,$Y:number,$size:number,$lineColor:number,$fillColor:number)
	$_screen.draw_triangle($X+$size/2,$Y, $X,$Y+$size, $X+$size,$Y+$size,$lineColor,$fillColor)
	
function @drawTriangleDown($_screen:screen,$X:number,$Y:number,$size:number,$lineColor:number,$fillColor:number)
	$_screen.draw_triangle($X+$size/2,$Y+$size, $X,$Y, $X+$size,$Y,$lineColor,$fillColor)

function @rotatedTriangleRad($_screen:screen,$_x:number,$_y:number,$_radians:number,$_height:number,$_width:number,$_lineColor:number,$_fillColor:number)
	var $_angle = $_radians - (pi/2) ; make 0 degrees point up
	var $bLx = cos($_angle+0.5*pi) * $_width
	var $bLy = sin($_angle+0.5*pi) * $_width
	var $bRx = cos($_angle-0.5*pi) * $_width
	var $bRy = sin($_angle-0.5*pi) * $_width
	var $tipX = cos($_angle) * $_height ;* -1
	var $tipY = sin($_angle) * $_height ;* -1
	$_screen.draw_triangle($_x+$bLx, $_y+$bLy,   $_x+$bRx, $_y+$bRy,   $_x+$tipX, $_y+$tipY, $_lineColor,$_fillColor)

function @rotatedTriangleUnit($_screen:screen,$_x:number,$_y:number,$_angleUnit:number,$_height:number,$_width:number,$_lineColor:number,$_fillColor:number)
	var $_angle = $_angleUnit * 2pi
	@rotatedTriangleRad($_screen,$_x,$_y,$_angle,$_height,$_width,$_lineColor,$_fillColor)

function @rotatedTriangleDeg($_screen:screen,$_x:number,$_y:number,$_angleDeg:number,$_height:number,$_width:number,$_lineColor:number,$_fillColor:number)
	var $_angle = ($_angleDeg/360) * 2pi
	@rotatedTriangleRad($_screen,$_x,$_y,$_angle,$_height,$_width,$_lineColor,$_fillColor)
	
function @rotatedTriangle_example($_screen:screen)
	@rotatedTriangleDeg($_screen,100,50,   45,  50,5,blue,green)
	@rotatedTriangleUnit($_screen,100,100, 1/8,  50,5,blue,yellow)
	@rotatedTriangleRad($_screen,100,150,  pi/4,  50,5,blue,red)

function @semiCircle($_screen:screen, $x:number, $y:number, $outer:number, $start_angle:number, $max_angle:number, $steps:number, $lineColor:number, $fillColor:number)
	; based on Trapdoor's draw_ring function for donuts
	$steps = 8; max(1, $max_angle*$steps/(2 * pi))
	var $angle_increment = $max_angle / $steps
	var $next_angle = 0
	

	var $firstC = cos($start_angle)
	var $firstS = sin($start_angle)
	var $firstX = $x + $outer * $firstC
	var $firstY = $y - $outer * $firstS
	var $lastAngle = $start_angle + $steps * $angle_increment
	var $lastC = cos($lastAngle)
	var $lastS = sin($lastAngle)
	var $lastX = $x + $outer * $lastC
	var $lastY = $y - $outer *  $lastS
	var $midX = ($firstX + $lastX) / 2
	var $midY = ($firstY + $lastY) / 2

	repeat $steps ($i)
		var $angle = $start_angle + $i * $angle_increment
		var $c = cos($angle)
		var $s = sin($angle)

		$next_angle = $angle + $angle_increment
		var $c_next = cos($next_angle)
		var $s_next = sin($next_angle)
		
		var $x1 = $midX
		var $y1 = $midY
		var $x2 = $x + $outer * $c
		var $y2 = $y - $outer * $s
		
		var $x4 = $x + $outer * $c_next
		var $y4 = $y - $outer * $s_next

		$_screen.draw_triangle($x1, $y1, $x2, $y2, $x4, $y4, $lineColor, $fillColor)

function @drawBattery($_screen:screen, $charge:number, $X:number, $Y:number, $W:number, $H:number, $text:text)
	$_screen.draw_rect($X-3,$Y+4,$X+1,$Y+$H-4,white,gray) ; nub
	$_screen.draw_rect($X,$Y,$X+$W,$Y+$H,white,black) ; main battery body
	if $charge > 0 && $charge < 0.06 ;smallest visible blue section if almost depleted
		$charge = 0.07
	if $charge > 0.06
		var $chargeW = $W * $charge
		$_screen.draw_rect($X+1,$Y+1,$X+$chargeW-1,$Y+$H-1,0,blue) ; draw charge
	else
		$_screen.draw_rect($X+1,$Y+1,$X+$W-1,$Y+$H-1,0,red) ; battery empty, draw red
	if size($text) > 0
		$_screen.write($X+5,$Y+(($H-$_screen.char_h)/2),white,$text)
		
function @drawRoundedRectangle($_screen:screen,$X:number,$Y:number,$width:number,$height:number,$radius:number,$lineColor:number,$fillColor:number)
	;example @drawRoundedRectangle(10,10,80,50,10,cyan,blue)
	var $right = $X + $width
	var $bottom = $Y + $height
	$_screen.draw_circle($X+$radius-1,$Y+$radius-1,$radius,$lineColor,$fillColor)
	$_screen.draw_circle($right-$radius,$Y+$radius-1,$radius,$lineColor,$fillColor)
	$_screen.draw_circle($X+$radius-1,$bottom-$radius,$radius,$lineColor,$fillColor)
	$_screen.draw_circle($right-$radius,$bottom-$radius,$radius,$lineColor,$fillColor)
	$_screen.draw_rect($X+$radius, $Y, $right-$radius, $bottom,0,$fillColor)
	$_screen.draw_rect($X,$Y+$radius,$right,$bottom-$radius,0,$fillColor)
	$_screen.draw_line($X+$radius, $Y, $right-$radius, $Y,$lineColor)
	$_screen.draw_line($X+$radius, $bottom, $right-$radius, $bottom,$lineColor)
	$_screen.draw_line($X, $Y+$radius, $X, $bottom-$radius,$lineColor)
	$_screen.draw_line($right, $Y+$radius, $right, $bottom-$radius,$lineColor)
	
function @drawSpeechBubble($_screen:screen,$X:number,$Y:number,$width:number,$height:number,$radius:number,$lineColor:number,$fillColor:number,$tailWidth:number,$tailLength:number)
	var $right = $X + $width
	var $bottom = $Y + $height
	if $tailLength == 0
		$tailLength = $height/2
	if $tailWidth == 0
		$tailWidth = $radius
	@drawRoundedRectangle($_screen,$X,$Y,$width,$height,$radius,$lineColor,$fillColor)
	$_screen.draw_triangle($X+$radius,$bottom-1, $X+$radius+$tailWidth,$bottom-1, $X+$radius/2,$bottom+$tailLength,0,$fillColor)
	$_screen.draw_line($X+$radius,$bottom-1,$X+$radius/2,$bottom+$tailLength,$lineColor)
	$_screen.draw_line($X+$radius+$tailWidth,$bottom,$X+$radius/2,$bottom+$tailLength,$lineColor)
	
function @drawHome($_screen:screen,$X:number,$Y:number,$size:number,$fillColor:number)
	var $left = $X-1 ; fixes not matching the surrounding box
	var $right = $X + $size
	var $bottom = $Y + $size
	var $houseChunk = $size/10
	var $roofline = $Y+$size/2
	;$_screen.draw_rect($X,$Y,$right,$bottom,red,0) ; box outline
	$_screen.draw_rect($left+$houseChunk*2,$roofline,$X+$houseChunk*4,$bottom,0,$fillColor)
	$_screen.draw_rect($left+$houseChunk*3,$roofline,$X+$houseChunk*7,$roofline+$houseChunk*2,0,$fillColor)
	$_screen.draw_rect($left+$houseChunk*6,$roofline,$X+$houseChunk*8,$bottom,0,$fillColor)
	$_screen.draw_triangle($left,$roofline,$right,$roofline,$X+$size/2,$Y,0,white)
	
function @drawHomeButton($_screen:screen,$X:number,$Y:number,$size:number,$fillColor:number):number
	$_screen.@drawHome($X,$Y,$size,$fillColor)
	return  $_screen.button_rect($X,$Y,$X+$size,$Y+$size,0,0)
	
function @drawChippy($_screen:screen,$cx:number,$cy:number)
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
	$_screen.draw_triangle($culx,$culy, $curx,$cury, $cblx,$cbly,0,$chippyColor)
	$_screen.draw_triangle($cbrx,$cbry, $curx,$cury, $cblx,$cbly,0,$chippyColor)
	$_screen.draw_line($culx,$culy,$curx,$cury,black)
	$_screen.draw_line($curx,$cury,$cbrx,$cbry,black)
	$_screen.draw_line($cbrx,$cbry,$cblx,$cbly,black)
	$_screen.draw_line($cblx,$cbly,$culx,$culy,black)
	$_screen.draw_line($culx+$lineDist,$culy+$lineDist, $cblx+$lineDist,$cbry-$lineDist,$chippyCopper)
	$_screen.draw_line($curx-$lineDist,$cury+$lineDist, $cbrx-$lineDist-1,$cbry-$lineDist*4,$chippyCopper)
	$_screen.draw_line($curx-$lineDist,$cury+$lineDist*8, $cbrx-$lineDist*6-1,$cbry-$lineDist*4,$chippyCopper)
	$_screen.draw_line($culx-$lineDist+20,$culy+$lineDist+10, $cblx+$lineDist+10,$cbly-$lineDist-4,$chippyCopper)
	$_screen.draw_line($culx+$lineDist+2,$culy+$lineDist+20, $culx+$lineDist+25,$culy+$lineDist+18,$chippyCopper)
	$_screen.draw_circle($culx+12,$culy+10,8,black,white)
	$_screen.draw_circle($culx+38,$culy+12,8,black,white)
	$_screen.draw_circle($culx+12,$culy+12,4,black,red)
	$_screen.draw_circle($culx+40,$culy+12,4,black,red)
	$_screen.draw_triangle($cblx+5,$cbly-1,$cblx+5,$cbly+20,$cblx+15,$cbly-1,black,color(10,30,10))
	$_screen.draw_triangle($cblx+26,$cbly-3,$cblx+27,$cbly+20,$cblx+35,$cbly-3,black,color(10,30,10))
	; end Chippy, please!

function @drawHeart($_screen:screen,$X:number,$Y:number,$filled:number)
	var $lineColor = red
	if $filled
		$_screen.draw_rect($X+1,$Y+1,$X+8,$Y+6,0,pink)
		$_screen.draw_rect($X+3,$Y+6,$X+6,$Y+8,0,pink)
	$_screen.draw_line($X+1,$Y,$X+4,$Y,$lineColor)
	$_screen.draw_point($X+4,$Y+1,$lineColor)
	$_screen.draw_line($X+5,$Y,$X+8,$Y,$lineColor)
	
	$_screen.draw_line($X,$Y+1,$X,$Y+5,$lineColor)
	$_screen.draw_line($X+8,$Y+1,$X+8,$Y+5,$lineColor)

	$_screen.draw_line($X+1,$Y+5,$X+5,$Y+9,$lineColor)
	$_screen.draw_line($X+7,$Y+5,$X+3,$Y+9,$lineColor)
