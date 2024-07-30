
; CHECK FOR SEA OR LAND -----------------------------------------------

; outputs 1 if the vehicle is in a water region (whether above or below the water) or 0 if the vehicle is above dry land.
function @isThisAtSea($seaLevel:number):number ; sea level is optional, assumes Earth if 0 (6203km)
	if $sealevel <= 0
		$seaLevel = 6203000
	var $thisIsOcean = 0
	var $altitudeAbsolute = input_number("altitude", 0) - $seaLevel
	var $altitudeTerrain = input_number("altitude", 1)
	var $terrainAltitude = $altitudeAbsolute - $altitudeTerrain
	if $terrainAltitude < 0
		$thisIsOcean = 1
	return $thisIsOcean



; VERTICAL SPEED -----------------------------------------------

; Calculates vertical speed without a nav instrument, using the altitude sensor
; To initialize the array that stores historical past altitudes:
;
; init
;	@verticalSpeedInit()
;
; Every tick, update the verical speed array
;
; update
; 	var $vspeed = @VerticalSpeed()


function @verticalSpeedInit()
	; creates the vertical speed history array. Edit the "repeat" number to alter the sensitivity
	repeat 10 ($i) ; size of the array dictates the responsiveness of the Vertical speed, high is smooth but slow
		$altitudeData.append(0)

function @VerticalSpeed() : number
	var $alt = input_number("altitude",0)
	$altitudeData.insert(0,$alt)
	$altitudeData.pop()
	return ($alt - $altitudeData.last) * (25/$altitudeData.size)