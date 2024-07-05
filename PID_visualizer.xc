var $screen = screen
array $values : number
var $sensor = 0

function @pid1($_setpoint:number, $_processvalue:number, $_kp:number, $_ki:number, $_kd:number, $_integral:number, $_prev_error:number) : number
	var $_error = $_setpoint - $_processvalue
	var $_dt = delta_time
	var $_derivative = ($_error - $_prev_error) / $_dt
	$_integral += $_error * $_dt
	$_prev_error = $_error
	return $_kp * $_error + $_ki * $_integral + $_kd * $_derivative

update
	$screen.blank(color(10,10,30))
	var $mySetpoint = input_number("lever", 0)*1
	;var $_input_alias_1 = input_number("myProcess", 0)
	var $_pid1 = @pid1($mySetpoint, $sensor, 0.6, 0.15, 0)
	$sensor += $_pid1 * 0.1
	$sensor *= 0.99 ; struggle
	output_number("myOut", 0, $_pid1)
	var $y0 = 80
	var $y1 = 10
	var $drawHeight = $y0-$y1
	var $ym1 = $y0+$drawHeight

	var $maxX = $screen.width-10
	var $minX = 30
	var $drawWidth = $maxX-$minX
	$screen.draw_line($minX,$y0,$maxX,$y0,white)
	$screen.draw_line($minX,$y1,$maxX,$y1,white)
	$screen.draw_line($minX,$ym1,$maxX,$ym1,white)
	var $setY = $y0-($mySetpoint*$drawHeight)
	$screen.draw_line($minX,$setY,$screen.width-10,$setY,color(20,20,60))
	$values.append($sensor)
	var $size = $values.size
	;print("size",$size)
	if $values.size > $drawWidth
		;print("size",$values.size,"erase")
		$values.erase(0)
	;print($mySetPoint,$_pid1,$sensor)
	foreach $values($i,$n)
		$screen.draw_point($minX+$i,$y0-($n*$drawHeight),red)
	$screen.write(10,$y1-3,white," 1")
	$screen.write(10,$y0-3,white," 0")
	$screen.write(10,$ym1-3,white,"-1")
	$screen.write(10,$setY-3,color(50,50,110),text("{0.000}",$mySetPoint))
