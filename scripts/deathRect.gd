extends Control

func fadeIn():
	# fades back into the content
	var tweenIn = get_tree().create_tween()
	tweenIn.tween_property($colourRect, "color:a", 0.0, 0.4)
	return tweenIn.finished
	
func fadeOut():
	# fades the screen to black
	var tweenOut = get_tree().create_tween()
	tweenOut.tween_property($colourRect, "color:a", 1.0, 0.4)
	return tweenOut.finished
