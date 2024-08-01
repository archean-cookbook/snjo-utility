function @pid($p : number, $i : number, $d : number, $min : number, $max : number) : text
	var $pid = ""
	$pid.kp = $p
	$pid.ki = $i
	$pid.kd = $d
	if $min == 0 and $max == 0
		$min = -2^32
		$max = 2^32

	$pid.min = $min
	$pid.max = $max
	$min = 0
	$max = 0
	return $pid

function @run_pid($pid : text, $sp : number, $pv : number) : text
	var $error = $sp - $pv
	var $p = $pid.kp * $error
	$pid.i = clamp($pid.i + $pid.ki * $error * delta_time, $pid.min, $pid.max)
	var $d = $pid.kd * ($error - $pid.last_error) / delta_time
	$pid.last_error = $error
	$pid.sum = $p + $pid.i + $d
	return $pid

init
	var $a = @pid(1, 0, 0)
	print("a: ", $a)
	var $b = @pid(1, 1, 0)
	print("b: ", $b)

	;once
	$a.@run_pid(1, 0)
	print("a: ", $a)
	$b.@run_pid(1, 0)
	print("b: ", $b)

	;twice
	$a.@run_pid(1, 0)
	print("a: ", $a)
	$b.@run_pid(1, 0)
	print("b: ", $b)