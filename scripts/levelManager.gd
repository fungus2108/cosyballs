extends Node

var levels = Array()
var levelsDir = "res://scenes/levels/"

# counter starts at -1 to account for menu; each level is +1 to the index
var levelIndex = -1

var isPaused = false

func _ready() -> void:
	populateLevelList(levelsDir)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().current_scene.name != "MainMenu":
		get_tree().paused = not get_tree().paused
		$HUD/Pausing.visible = not $HUD/Pausing.visible
		
	if Input.is_action_just_pressed("quit") and get_tree().current_scene.name != "MainMenu":
		if not get_tree().paused:
			await DeathRect.fadeOut()
			levelIndex = -1
			get_tree().change_scene_to_file("res://scenes/menus/mainMenu.tscn")
	
	
func populateLevelList(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.ends_with(".import"):
					pass
				else:
					levels.append(levelsDir + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the levels.")
 
func levelSwitch():
	await DeathRect.fadeOut()
	GlobalAudio.broomAudioOff()
	levelIndex += 1
	
	if levelIndex > (levels.size() - 1):
		get_tree().change_scene_to_file("res://scenes/menus/winScreen.tscn")
	else:
		get_tree().change_scene_to_file(levels[levelIndex])
		DeathRect.fadeIn()
