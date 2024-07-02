; ------------- HSV to RGB by trapdoor -----------
; $h: [0, 360]
; $s: [0, 1]
; $v: [0, 1]
function @hsv_to_rgb($h:number, $s:number, $v:number) : number
	var $rgb = 0
	$h %= 360
	var $c = $v * $s
	var $x = $c * (1 - abs(($h / 60) % 2 - 1))
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
;This should perform identically to @hsv_to_rgb above, just internally different
function @ColorFromHSV($hue:number, $saturation:number, $value:number):number	
	;//https://stackoverflow.com/questions/1335426/is-there-a-built-in-c-net-system-api-for-hsv-to-rgb
	;//https://en.wikipedia.org/wiki/HSL_and_HSV
	var $hi = floor($hue / 60) % 6
	var $f = $hue / 60 - floor($hue / 60)
	$value = $value * 255
	var $v = $value
	var $p = $value * (1 - $saturation)
	var $q = $value * (1 - $f * $saturation)
	var $t = $value * (1 - (1 - $f) * $saturation)

	if $hi == 0
		return color($v, $t, $p)
	elseif ($hi == 1)
		return color($q, $v, $p)
	elseif ($hi == 2)
		return color($p, $v, $t)
	elseif ($hi == 3)
		return color($p, $q, $v)
	elseif ($hi == 4)
		return color($t, $p, $v)
	else
		return color($v, $p, $q)

; -------------------------------------------------	

function @heatmapColor($value:number,$saturation:number,$brightness:number):number ; outputs a color from 0:blue through red to 1:yellow
	var $shiftHue = 0.7
	var $shifted = mod(($value/2)+$shiftHue,1)
	var $Hue = ($shifted*360)
	var $color = @hsv_to_rgb($hue,$saturation,$brightness)
	return $color

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

function @getHue($color:number):number
	var $red = color_r($color)
	var $green = color_g($color)
	var $blue = color_b($color)
	var $min = min(min($red, $green), $blue)
	var $max = max(max($red, $green),  $blue)

	if $min == $max
		return 0

	var $hue = 0
	if $max == $red
		$hue = ($green - $blue) / ($max - $min)
	elseif $max == $green
		$hue = 2 + ($blue - $red) / ($max - $min)
	else
		$hue = 4 + ($red - $green) / ($max - $min)

	$hue = $hue * 60;
	if $hue < 0
		$hue = $hue + 360

	return $hue

function @ColorToHSV($color:number):text
	; returns a kvp, access the result like this	
	; $hsv = @ColorToHSV($color)
	; $hsv.hue  $hsv.saturation   $hsv.value (or $hsv.brightness)
	var $max = max(color_r($color), max(color_g($color), color_b($color)))
	var $min = min(color_r($color), min(color_g($color), color_b($color)))
	var $hue = @getHue($color)
	var $saturation = 0
	if $max == 0
		$saturation = 0
	else
		$saturation = 1 - (1 * $min / $max)
	var $value = $max / 255
	var $result = ""
	$result.hue = $hue
	$result.saturation = $saturation
	$result.value = $value
	$result.brightness = $value ; redundant but helpful
	return $result