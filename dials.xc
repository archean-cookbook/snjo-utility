var $dialEdgeColor = color(60,60,70)
var $dialFaceColor = color(20,20,20)
var $dialNumbers = color(45,45,45)

; ------------------- VERTICAL SPEED INDICATOR (VSI) -----------------------------

; Example
; init (or update if you're blanking the screen on update)
; 	@VSIdialBackground($screenInstruments,50,50,45)
; update
; 	@VSIdialUpdate($screenInstruments,50,50,45,"Vert.\nspeed",$verticalspeed,-5,5)

function @VsiDialBackground($_screen:screen,$_x:number,$_y:number,$_size:number)
	$_screen.draw_circle($_x,$_y,$_size,$dialEdgeColor,$dialFaceColor)
	var $piQ = pi/4
	; value 0
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

function @VsiDialCenter($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text)
	$_screen.draw_circle($_x,$_y,$_size*0.8,0,$dialFaceColor)
	$_screen.write(15+$_x-$_size,$_y-3,$dialNumbers,"0")
	$_screen.write(18+$_x-$_size,$_y-20,$dialNumbers,"+1")
	$_screen.write(18+$_x-$_size,$_y+13,$dialNumbers,"-1")
	$_screen.write($_x-8,$_y-$_size+15,$dialNumbers,"+5")
	$_screen.write($_x-8,$_y+$_size-21,$dialNumbers,"-5")
	$_screen.write($_x+10,$_y-$_size+23,$dialNumbers,"+20")
	$_screen.write($_x+10,$_y+$_size-30,$dialNumbers,"-20")
	$_screen.write($_x+10,$_y-6,white,$_label)


function @VsiDialUpdate($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text,$_value:number,$_minVSI:number,$_maxVSI:number)
	@VSIdialCenter($_screen,$_x,$_y,$_size,$_label);$_minVSI,$_maxVSI,
	$_value.clamp(-20,20) ; limit needle going past last notch
	var $logvalue = 0
	if $_value > 0
		$logvalue = log($_value+1,2.2)
	else
		$logvalue = -log(-$_value+1,2.2)
	var $range = $_maxVSI-$_minVSI
	var $needleLength = $_size * 0.75
	var $angle = clamp($logvalue/$range,-0.4,0.4)-0.25 ; -.25 to point left
	$_screen.@rotatedTriangleUnit($_x,$_y,$angle,$needleLength,5,0,white)
	
; ------------------- ROLL INDICATOR -----------------------------

function @artificialHorizonBackground($_screen:screen,$_x:number,$_y:number,$_size:number)
	$_screen.draw_circle($_x,$_y,$_size,$dialEdgeColor,$dialFaceColor)
	var $piQ = pi/4
	$_screen.@rotatedTriangleDeg($_x-cos(0)*$_size,$_y-sin(0)*$_size,-90,-10,4,0,white)
	$_screen.@rotatedTriangleDeg($_x-cos(pi)*$_size,$_y-sin(pi)*$_size,-90,10,4,0,white)
	$_screen.draw($_x-$_size,$_y,gray,$_size*2,1)

function @artificialHorizonCenter($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text)
	$_screen.draw_circle($_x,$_y,$_size*0.8,0,$dialFaceColor)
	$_screen.write($_x+10,$_y-6,white,$_label)

function @artificialHorizonUpdate($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text,$_roll:number,$_pitch:number)
	;@artificialHorizonCenter($_screen,$_x,$_y,$_size,$_label)
	var $pitchY = clamp($_pitch * $_size,-$_size*0.75,$_size*0.75);$_pitch 
	$_roll *= -0.5
	var $rollRad = $_roll * pi
	var $r1X = (cos($rollRad) * $_size * 0.75)
	var $r1Y = (sin($rollRad) * $_size * 0.75)
	print($_roll)
	$_screen.@rotatedTriangleUnit($_x, $_y+$pitchY, $_roll+0.25 ,30,4,0,white)
	$_screen.@rotatedTriangleUnit($_x, $_y+$pitchY, $_roll-0.25 ,30,4,0,white)
	$_screen.@rotatedTriangleUnit($_x, $_y+$pitchY, $_roll ,23,4,0,white)