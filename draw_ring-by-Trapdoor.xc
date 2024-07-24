function @draw_ring($x : number, $y : number, $inner : number, $outer : number, $start_angle : number, $max_angle : number, $color : number, $fcolor : number, $steps : number) : number
	$steps = max(1, $max_angle*$steps/(2 * pi))
	var $angle_increment = $max_angle / $steps
	var $next_angle = 0
	repeat $steps ($i)
		var $angle = $start_angle + $i * $angle_increment
		var $c = cos($angle)
		var $s = sin($angle)
		$next_angle = $angle + $angle_increment
		var $c_next = cos($next_angle)
		var $s_next = sin($next_angle)
		var $x1 = $x + $inner * $c
		var $y1 = $y - $inner * $s
		var $x2 = $x + $outer * $c
		var $y2 = $y - $outer * $s
		var $x3 = $x + $inner * $c_next
		var $y3 = $y - $inner * $s_next
		var $x4 = $x + $outer * $c_next
		var $y4 = $y - $outer * $s_next
		draw_triangle($x2, $y2, $x3, $y3, $x1, $y1, $color, $fcolor)
		draw_triangle($x2, $y2, $x3, $y3, $x4, $y4, $color, $fcolor)
	$color = 0
	$fcolor = 0
	$steps = 32
	return $next_angle

var $ticks = 0

update
		$ticks++
		var $span = (sin($ticks / 50) + 1) * pi / 5
	var $start = 0
	$start = @draw_ring(80, 20, 10, 16, $start, $s, red, red)
	$start = @draw_ring(80, 20, 10, 16, $start, $s, orange, orange)
	$start = @draw_ring(80, 20, 10, 16, $start, $s, yellow, yellow)
	$start = @draw_ring(80, 20, 10, 16, $start, $s, green, green)
	@draw_ring(80, 20, 10, 16, $start, $s, blue, blue)