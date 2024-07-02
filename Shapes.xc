; these functions use $dashCfg to determine the screen to draw to. If the $dashCfg is set up in the main file,
; the draw functions can ble placed in a separate file and work like static methods

; in main file, set up dashConfigs
var $dashCfgDials = ""
var $dashCfgGPS = ""
init
	$dashCfgDials.dashName = "dashboard" ; the port number name of the dashboard (set with V)
	$dashCfgGPS.dashName = "dashboard"

	$dashCfgDials.screen = 0 ; the channel number/index of element on the dashboard
	$dashCfgGPS.screen = 1
	
; example of calling one of the methods below
tick
	@drawBattery($dashCfgDials,$battCharge, $battX, $battY, $battW, $battH, "Left") ; draws to the first screen on the dash
	@drawTriangle($dashCfgGPS,10,50,30,green) ; draws to the second screen on the dash

; standalone/static methods, can be put in separate file

function @drawTriangle($dashCfg:text,$X:number,$Y:number,$size:number,$color:number)
	var $screen = screen($dashCfg.dashName,$dashCfg.screen:number)
	$screen.draw_triangle($X+$size/2,$Y, $X,$Y+$size, $X+$size,$Y+$size,$color)

function @drawBattery($dashCfg:text, $charge:number, $X:number, $Y:number, $W:number, $H:number, $text:text)
	var $screen = screen($dashCfg.dashName,$dashCfg.screen:number)
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
		

