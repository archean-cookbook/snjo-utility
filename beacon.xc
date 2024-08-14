; Beacon display. Edit beaconchannels.xc to add your own beacons
var $screenBeacon = screen("dashRight",1)
array $GPStargets:number
array $GPSknown:text
var $GPSindex = 0
include "beaconchannels.xc"

function @getBeaconData($channel:number):text
	var $result = ""
	$result.data = input_text("beacon", 0) ; result from last tick
	;print($result.data)
	$result.distance = input_number("beacon", 1)
	$result.dx = input_number("beacon", 2)
	$result.dy = input_number("beacon", 3)
	$result.dz = input_number("beacon", 4)
	$result.receiving = input_number("beacon", 5)
	$result.inFront = $result.dZ < 0
	return $result
	
function @drawDirection($screenX:screen,$left:number,$top:number,$width:number,$height:number,$target:text)
	var $right = $left+$width
	var $bottom = $top+$height
	var $centerX = $left + ($width/2)
	var $color = color(100,50,0)
	if $target.inFront
		$color = color(0,0,100)
	if $target.receiving == 0
		$color = gray
	$screenX.draw_rect($left,$top,$right,$bottom,white,$color)
	$screenX.draw_line($centerX,$top,$centerX,$bottom,white)
	var $lineFaint = color(0,0,0,100)
	$screenX.draw_rect($centerX-($width/8)-1,$top+1,$centerX-($width/8)+1,$bottom-1,0,$lineFaint)
	$screenX.draw_rect($centerX+($width/8)-1,$top+1,$centerX+($width/8)+1,$bottom-1,0,$lineFaint)
	$screenX.draw_rect($centerX-($width/4)-1,$top+1,$centerX-($width/4)+1,$bottom-1,0,$lineFaint)
	$screenX.draw_rect($centerX+($width/4)-1,$top+1,$centerX+($width/4)+1,$bottom-1,0,$lineFaint)
	var $pos = $centerX + ($target.dX*$width*0.5)
	var $textY = $top+(($height-$screenX.char_h)/2)
	if $target.receiving == 1
		if $target.infront
			$screenX.draw_triangle($pos,$top,$pos+5,$bottom-1,$pos-5,$bottom-1,white,red)
		else
			$screenX.draw_triangle($pos,$bottom-1,$pos+5,$top,$pos-5,$top,white,red)
		$screenX.write($right-55,$textY,white, floor($target.distance):text & " m")
	$screenX.write($left+10,$textY,white,$target.data)
	
function @updateBeaconUI($screenX:screen,$X:number,$Y:number,$width:number,$height:number)
	var $target = @getBeaconData($GPStargets.$GPSindex)
	if $GPSknown.size <= $GPSindex
		if ($target.receiving)
			$GPSknown.append($target)
	else
		$GPSknown.$GPSindex = $target
	
	var $count = size($GPSknown)
	repeat $count ($i)
		@drawDirection($screenX,$X,$Y+(($height+5)*$i),$width,$height,$GPSknown.$i)
	
	$GPSindex++
	if $GPSindex >= size($GPStargets)
		$GPSindex = 0
	output_number("beacon",2,$GPStargets.$GPSindex) ; next target
	
update
	$screenBeacon.blank(black)
	if size($GPStargets) == 0
		@setBeaconTargets()
		;print("make list")
	else
		@updateBeaconUI($screenBeacon,20,10,230,20)
		;print("update list",$GPStargets.size)
	
	