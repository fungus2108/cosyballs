extends Node


func _ready() -> void:
	broomAudioToggle()


func broomAudioToggle():
	$broomSweep.stream_paused = !$broomSweep.stream_paused
		

func broomAudioOff():
	$broomSweep.stream_paused = true
