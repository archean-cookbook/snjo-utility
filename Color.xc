; ------------- HSV to RGB by trapdoor -----------
; $h: [0, 360]
; $s: [0, 1]
; $v: [0, 1]
function @hsv_to_rgb($h:number, $s:number, $v:number) : number
	var $rgb = 0
	$h %= 360
	var $c = $v * $s
	var $x = $c * (1 - abs($h / 60) % 2 - 1)
	var $m = $v - $c
	
	if $h < 60
		$rgb = color(($c + $m) * 255, ($x + $m) * 255, ($m) * 255)
	elseif $h < 120
		$rgb = color(($x + $m) * 255, ($c + $m) * 255, ($m) * 255)
	elseif $h < 180
		$rgb = color(($m) * 255, ($c + $m) * 255, ($x + $m) * 255)
	elseif $h < 240
		$rgb = color(($m) * 255, ($x + $m) * 255, ($c + $m) * 255)
	elseif $h < 300
		$rgb = color(($x + $m) * 255, ($m) * 255, ($c + $m) * 255)
	elseif $h <= 360
		$rgb = color(($c + $m) * 255, ($m) * 255, ($x + $m) * 255)

	return $rgb
; -------------------------------------------------

function @ColorValue($color:number):number
	; returns a value of 0-1f based on the total brightness of the input color
	; https://stackoverflow.com/questions/596216/formula-to-determine-perceived-brightness-of-rgb-color
	; https://en.wikipedia.org/wiki/Relative_luminance
	; perceived value (0.2126 * R + 0.7152 * G + 0.0722 * B)
	var $pR = 0.2126
	var $pG = 0.7152
	var $pB = 0.0722
	;var $result = (color_r($color) * $pR +	color_g($color) * $pG +	color_b(c$olor) * $pB) / 256
	var $result = ((color_r($color) * $pR) + (color_g($color) * $pG) + (color_b($color) * $pB)) / 256
	return $result	

function @TextColorFromBackColor($backColor:number,$threshold:number):number 
	; returns black if the backColor is bright, returns white if the backColor is dark
	; adjust where it flips from dark to light with $threschold. 0.4 is probably a good threshold
	var $result = black
	if @ColorValue($backColor) < $threshold
		$result = white
	return $result
