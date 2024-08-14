; Add your beacons here to display them on screen. This is an example list.
; This is used in combination with beacon.xc

function @setBeaconTargets()
	$GPStargets.append(1000) ; HQ
	$GPStargets.append(1001) ; Example 
	$GPStargets.append(3001) ; A vehicle
	$GPStargets.append(3003) ; a quadcopter