var $dialEdgeColor = color(60,60,70)
var $dialFaceColor = color(20,20,20)

function @VSIdial($_screen:screen,$_x:number,$_y:number,$_size:number,$_value:number,$_minVSI:number,$_maxVSI:number,$_label:text)
	$_screen.draw_circle($_x,$_y,$_size,$dialEdgeColor,$dialFaceColor)

	$_screen.write($_x-($_screen.char_w*size($_label)*0.5),$_y+$_size/4,white,$_label)

	$_value.clamp(-20,20) ; limit needle going past last notch

	var $logvalue = 0
	if $_value > 0
		$logvalue = log($_value+1,2.2)
	else
		$logvalue = -log(-$_value+1,2.2)

	var $range = $_maxVSI-$_minVSI
	var $needleLength = $_size * 0.8
	var $angle = clamp($logvalue/$range,-0.4,0.4)-0.25 ; -.25 to point left
	$_screen.write(15+$_x-$_size,$_y-3,gray,"0")
	$_screen.write(18+$_x-$_size,$_y-20,gray,"+1")
	$_screen.write(18+$_x-$_size,$_y+13,gray,"-1")
	$_screen.write($_x-8,$_y-$_size+15,gray,"+5")
	$_screen.write($_x-8,$_y+$_size-21,gray,"-5")
	$_screen.write($_x+10,$_y-$_size+23,gray,"+20")
	$_screen.write($_x+10,$_y+$_size-30,gray,"-20")
	var $piQ = pi/4
	$_screen.@rotatedTriangleDeg($_x-cos(0)*$_size,$_y-sin(0)*$_size,-90,-10,4,0,white)
	
	; value 1
	$_screen.@rotatedTriangleDeg($_x-cos($piQ*0.75)*$_size,$_y-sin($piQ*0.75)*$_size,-45,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos(-$piQ*0.75)*$_size,$_y-sin(-$piQ*0.75)*$_size,45,10,4,0,gray)
	; value 5
	$_screen.@rotatedTriangleDeg($_x-cos(-$piQ*1.9)*$_size,$_y-sin(-$piQ*1.9)*$_size,0,10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos(-$piQ*-1.9)*$_size,$_y-sin(-$piQ*-1.9)*$_size,0,-10,4,0,gray)
	; value 20
	$_screen.@rotatedTriangleDeg($_x-cos($piQ*3.09)*$_size,$_y-sin($piQ*3.09)*$_size,45,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos(-$piQ*3.09)*$_size,$_y-sin(-$piQ*3.09)*$_size,-45,10,4,0,gray)
	$_screen.@rotatedTriangleUnit($_x,$_y,$angle,$needleLength,5,0,white)