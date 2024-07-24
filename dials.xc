var $dialEdgeColor = color(60,60,70)
var $dialEdgeColor2 = color(28,28,28)
var $dialFaceColor = color(20,20,20)
var $dialFaceColor2 = color(15,15,15)
var $dialNumbers = color(45,45,45)
array $altitudeData : number

; ------------------- VERTICAL SPEED INDICATOR (VSI) -----------------------------

; Example
; init (or update if you're blanking the screen on update)
; 	@VSIdialBackground($screenInstruments,50,50,45)
; update
; 	@VSIdialUpdate($screenInstruments,50,50,45,"Vert.\nspeed",$verticalspeed,-5,5)

; If you don't use a nav instrument, calculate Vertical speed like this:
; init
;	@verticalSpeedInit()
;
; update
; 	var $vspeed = @VerticalSpeed()
;	@VSIdialUpdate($screenInstruments,150,50,45,"Vert.\nspeed",$vspeed,-5,5)

function @verticalSpeedInit()
	repeat 10 ($i) ; size of the array dictates the responsiveness of the Vertical speed, high is smooth but slow
		$altitudeData.append(0)

function @VerticalSpeed() : number
	var $alt = input_number("altitude",0)
	$altitudeData.insert(0,$alt)
	$altitudeData.pop()
	return ($alt - $altitudeData.last) * (25/$altitudeData.size)

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
	
; ------------------- ROLL INDICATOR, SIMPLE ARTIFICIAL HORIZON -----------------------------

function @artificialHorizonPitch($_screen:screen,$_x:number,$_y:number,$_size:number,$_pitch:number)
	; draws a horizon line (flat) at the pitch level
	$_pitch = $_pitch * (pi/2) ; convert unit pitch to circle radians
	var $_radius = $_size*0.75 ; inner circle size
	; get vector end, the point along the circle to put the horizon plane at
	var $horX = cos($_pitch)*$_radius
	var $horY = sin($_pitch)*$_radius
	; draw from the vector end and its opposite, a box representing the horizon plane
	$_screen.draw_rect($_x-$horX,$_y-$horY,$_x+$horX,$_y-$horY+3,0,white)
	; hide the edge of the box with a thick circle
	var $horEdge = color(30,30,30)


function @artificialHorizonCenter($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text,$_pitch:number,$_roll:number)
	; back plate
	$_screen.draw_circle($_x,$_y,$_size,0,$dialFaceColor)
	$_screen.draw_circle($_x,$_y,$_size*0.8,0,color(15,15,40));$dialFaceColor2)
	var $groundColor = color(40,30,15)
	$_screen.write($_x+10,$_y-6,white,$_label)
	@semiCircle($_screen, $_x, $_y, $_size*0.75, $_pitch*(pi/2), -pi-$_pitch*(pi), 8, $groundColor, $groundColor)
	@artificialHorizonPitch($_screen,$_x,$_y,$_size,$_pitch)
	; draw the masking donut
	$_screen.@draw_ring($_x, $_y, $_size * 0.75, $_size*0.97, 0, 2pi, $dialFaceColor, $dialFaceColor,16)
	; inner donut edge
	$_screen.draw_circle($_x,$_y,$_size*0.76,$dialEdgeColor2,0)
	; outer edge
	$_screen.draw_circle($_x,$_y,$_size,$dialEdgeColor,0)
	; alignment markers
	var $piQ = pi/4
	$_screen.@rotatedTriangleDeg($_x-cos(0)*$_size,$_y-sin(0)*$_size,-90,-10,4,0,white)
	$_screen.@rotatedTriangleDeg($_x-cos(pi)*$_size,$_y-sin(pi)*$_size,-90,10,4,0,white)
	; level flight line


	$_screen.draw($_x-$_size,$_y,gray,$_size*2,1)
	;@semiCircle($_screen, $_x, $_y, $_size*0.75, $_pitch*(pi/2), -3, 8, red, green)

function @artificialHorizonNeedle($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text,$_roll:number,$_pitch:number)
	var $pitchY = clamp($_pitch * $_size,-$_size*0.75,$_size*0.75);$_pitch 
	$_roll *= -0.5
	var $rollRad = $_roll * pi
	var $r1X = (cos($rollRad) * $_size * 0.75)
	var $r1Y = (sin($rollRad) * $_size * 0.75)
	;print($_roll)
	$_screen.@rotatedTriangleUnit($_x, $_y+$pitchY, $_roll+0.25 ,30,4,0,white)
	$_screen.@rotatedTriangleUnit($_x, $_y+$pitchY, $_roll-0.25 ,30,4,0,white)
	$_screen.@rotatedTriangleUnit($_x, $_y+$pitchY, $_roll ,23,4,0,white)
	
	
; -------------------- SPEED -------------------------

function @speedDialBackground($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text)
	$_screen.draw_circle($_x,$_y,$_size,$dialEdgeColor,$dialFaceColor)
	var $piQ = pi/4
	$_screen.@rotatedTriangleDeg($_x-cos(-$piQ)*$_size,$_y-sin(-$piQ)*$_size,225,-10,4,0,white)
	$_screen.@rotatedTriangleDeg($_x-cos(0)*$_size,$_y-sin(0)*$_size,270,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos($piQ)*$_size,$_y-sin($piQ)*$_size,315,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos($piQ*2)*$_size,$_y-sin($piQ*2)*$_size,360,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos($piQ*3)*$_size,$_y-sin($piQ*3)*$_size,45,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos($piQ*4)*$_size,$_y-sin($piQ*4)*$_size,90,-10,4,0,gray)
	$_screen.@rotatedTriangleDeg($_x-cos($piQ*5)*$_size,$_y-sin($piQ*5)*$_size,135,-10,4,0,red)
	;$_screen.draw($_x-$_size,$_y,gray,$_size*2,1)

function @speedDialCenter($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text)
	$_screen.draw_circle($_x,$_y,$_size*0.8,0,$dialFaceColor)
	$_screen.write($_x-13,$_y+30,gray,$_label)
	$_screen.write($_x-22,$_y+18,gray,"0")
	$_screen.write($_x-32,$_y-2,gray,"20")
	$_screen.write($_x-22,$_y-22,gray,"40")
	$_screen.write($_x-4,$_y-30,gray,"60")
	$_screen.write($_x+12,$_y-22,gray,"80")
	$_screen.write($_x+16,$_y-2,gray,"100")
	$_screen.write($_x+8,$_y+18,gray,"120")
			
function @speedDialUpdate($_screen:screen,$_x:number,$_y:number,$_size:number,$_label:text,$_speed:number,$_maxSpeed:number)
	; max speed represents the whole circle, so 160 even if the last drawn value is 120
	@speedDialCenter($_screen,$_x,$_y,$_size,$_label)
	var $needleLength = $_size * 0.75
	;$_speed = 130
	$_speed.clamp(0,120)
	$_speed -= 60
	$_speed = ($_speed / $_maxSpeed)
	var $angle = $_speed; *0.01
	$_screen.@rotatedTriangleUnit($_x,$_y,$angle,$needleLength,5,0,white)

; -------------------- ALTITUDE ----------------------