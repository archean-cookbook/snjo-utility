
; IN USE:
; ; CREATE THROTTLE VAR
; var $throttle = ""
;
; init
;   ; SET THE DEADZONE
;	$throttle.deadZoneMax = 0.1
;	$throttle.deadZoneMin = -0.2
;
; update
;
;   ; UPDATE THE THROTTLE VALUE
;	$throttle = @applyDeadzone($throttle)
;
;   ; DRAW THE THROTTLE TO SCREEN
;	$screen.@drawThrottle($throttle,10,10,20,80,white,green,gray,orange)
;

	var $throttleClick = @drawThrottle($screen,$throttle,220,10,30,220,white,green,gray,orange)
	if $throttleClick.clicked
		$throttle.value = $throttleClick.value:number
		;print("set throttle to",$throttleClick.value)
	$throttle = @applyDeadzone($throttle)
	$throttle.value = clamp($throttle.value,-1,1)
	var $percent = floor($throttle.final*100)
	var $percentText = $percent:text & "%"
	var $percentTextX = $screen.char_w * size($percentText) / 2
	$screen.write(210,240,white,"THROTTLE")
	$screen.write(235-$percentTextX,250,white,$percentText)
	
;   ; DRAW PERCENT THROTTLE
;	$screenLarge.write(14,155,white,"THR")
;	var $percent = floor($throttle.final*100):text & "%"
;	if $percent < 100
;		$percent = " " & $percent
;	if $percent < 10
;		$percent = " " & $percent
;	$screen.write(13,165,white,$percent)

	
; -----
; IN NAV HUD COMPUTER
function @applyDeadzone($object:text):text
	if $object.value > $object.deadZoneMax
		var $topZone = 1-$object.deadZoneMax
		$object.final = ($object.value - $object.deadZoneMax)/$topZone
		;print("top:",$topZone)
	elseif $object.value < $object.deadZoneMin
		var $bottomZone = 1+$object.deadZoneMin
		$object.final = ($object.value - $object.deadZoneMin)/$bottomZone
		;print("bottom:",$bottomZone)
	else; $object.final < $object.deadZoneMax && $object.final > $object.deadZoneMin
		$object.final = 0
	return $object

function @drawThrottle($screen:screen,$object:text,$X:number,$top:number,$width:number,$height:number,$borderColor:number,$topColor:number,$midColor:number,$bottomColor:number):text
	var $MinMaxZoneHeight = 10
	var $rangeTop = $top+$MinMaxZoneHeight+1
	var $rangeBottom = $top+$height-$MinMaxZoneHeight
	var $rangeHeight = $rangeBottom - $rangeTop
	var $leftInt = $X+1
	;var	$heightInt = $height - 2 - $MinMaxZoneHeight*2
	var $widthInt =  $width - 2
	;var $bottomInt = $rangeTop+$heightInt
	var $rightInt = $X+$widthInt
	var $CenterY = ($rangeTop+1) + (($rangeHeight)/2)


	var $topZoneHeight = ($rangeHeight/2) * (1-$object.deadZoneMax)
	var $bottomZoneHeight = ($rangeHeight/2) * (1+$object.deadZoneMin) - 2
	;$screen.draw_rect($X-8,$centerLineY, $X-2,$centerLineY+($rangeHeight/2)*abs($object.deadZoneMin),red) ; TEST
	
	$screen.draw_rect($X,$rangeTop-1,$X+$width,$rangeBottom+1,$borderColor,$midColor) ; GRAY MIDDLE
	$screen.draw_rect($leftInt,$rangeTop,$rightInt+1,$rangeTop+$topZoneHeight+1,0,$topColor) ; GREEN TOP
	$screen.draw_rect($leftInt, $rangeBottom-$bottomZoneHeight, $rightInt+1, $rangeBottom,0,$bottomColor) ; ORANGE BOTTOM
	$screen.draw_line($X,$CenterY,$X+$width,$CenterY,white)
	;var $indicatorY = clamp($CenterY - ($height/2)*$object.value, $rangeTop, $rangeBottom)
	var $indicatorY = clamp($centerY - ($rangeHeight/2)*$object.value, $rangeTop, $rangeBottom-1)
	var $indicatorX = $X
	$screen.draw_triangle($indicatorX+10,$indicatorY,$indicatorX,$indicatorY-5,$X,$indicatorY+5,red,red)
	$indicatorX = $X+$width-1
	$screen.draw_triangle($indicatorX-10,$indicatorY,$indicatorX,$indicatorY-5,$indicatorX,$indicatorY+5,red,red)

	var $out = ""
	$out.clicked = 0
	
	var $minMaxColorMult = 0.3
	var $maxColor = color(color_r($topColor)*$minMaxColorMult,color_g($topColor)*$minMaxColorMult,color_b($topColor)*$minMaxColorMult)
	var $minColor = color(color_r($bottomColor)*$minMaxColorMult,color_g($bottomColor)*$minMaxColorMult,color_b($bottomColor)*$minMaxColorMult)

	if $screen.button_rect($X,$top,$X+$width,$rangeTop,white,$maxColor)
		$out.value = 1
		$out.clicked = 1
	$screen.write($X+$width/2-8,$top+2,white,"MAX")
	
	if $screen.button_rect($X,$rangeBottom,$X+$width,$top+$height+1,white,$minColor)
		$out.value = -1
		$out.clicked = 1
	$screen.write($X+$width/2-8,$rangeBottom+2,white,"MIN")

	if $screen.button_rect($X,$rangeTop,$X+$width,$rangeBottom,0,0)
		var $bY = $screen.click_y - $rangeTop
		$out.value = 1-($bY / $rangeHeight)*2
		$out.clicked = 1
		return $out
	else
		return $out
		

		
