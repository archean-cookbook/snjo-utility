function @drawScrollBar($X:number,$Y:number,$width:number,$height:number,$position:number,$max:number)
	; SCROLL VIEW
	if $max < 1
		$max = 1
		
	var $buttonHeight = $height/4
	var $arrowSize = $width-6
	var $margin = ($width - $arrowSize)/2
	
	;UP
	if @button($X,$Y,$width,$buttonHeight,0,gray,"")
		$scroll -= $linesOnScreen-2
		if $scroll < 0
			$scroll = 0
	@drawTriangleUp($X+$margin,$Y+$buttonHeight/2-$margin,$width-$margin*2,0,white)
	
	; DOWN
	if @button($X,$height-$buttonHeight,$width,$buttonHeight,0,gray,"")
		$scroll += $linesOnScreen-3
		if $scroll >= $itemLines
			$scroll = $itemLines-1
		if $scroll < 0
			$scroll = 0
	@drawTriangleDown($X+$margin,(screen_h-$buttonHeight)+$buttonHeight/2-$margin,$width-$margin*2,0,white)
	
	var $scrollBoxTop = $buttonHeight + 2
	var $scrollBoxBottom = $height - $buttonHeight - 7
	var $scrollBoxHeight = $scrollBoxBottom - $scrollBoxTop
	var $indicatorY = $scrollBoxTop + $scrollBoxHeight * ($position/$max)
	if @button($X,$scrollBoxTop,$width,$scrollBoxHeight+5,0,color(20,20,20),"")
		var $clickY = click_y - $scrollBoxTop
		var $clickNormalized = $clickY / $scrollBoxHeight
		var $newScroll = min(floor($max * $clickNormalized),$max)
		print("scroll click",$clickNormalized,"new",$newScroll,"max",$max)
		$scroll = $newScroll
		;var $newScroll = 
	draw_rect($X,$indicatorY,$X+$width,$indicatorY+5,0,white)