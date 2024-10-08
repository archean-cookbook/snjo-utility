; PID function by Trapdoor

function @pid($p : number, $i : number, $d : number, $min : number, $max : number) : text
    var $pid = ""
    $pid.kp = $p
    $pid.ki = $i
    $pid.kd = $d
    if $min == 0
        $pid.min = -2^32
    else
        $pid.min = $min
        
    if $max == 0
        $pid.max = 2^32
    else
        $pid.max = $max
    return $pid
    
function @run_pid($pid : text, $sp : number, $pv : number) : text
    var $error = $sp - $pv
    var $p = $pid.kp * $error
    $pid.i = clamp($pid.i + $pid.ki * $error * delta_time, $pid.min, $pid.max)
    var $d = $pid.kd * ($error - $pid.last_error) / delta_time
    $pid.last_error = $error
    $pid.sum = $p + $pid.i + $d
    return $pid
	
; EXAMPLES -----------

// PID with P: 1, I: 0, D: 0, no integral limit
var $somePID = @pid(1, 0, 0)

// PID with P: 0.5, I: 1, D: 0, integral limit between -0.2 and 0.2
var $anotherPID = @pid(0.5, 1, 0, -0.2, 0.2)

// update $somePID
$somePID = @run_pid($somePID, setpoint, process variable)

// update $anotherPID
$anotherPID = @run_pid($anotherPID, setpoint, process variable)
