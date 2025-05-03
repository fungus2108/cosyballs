extends Node

var levels = Array()
var levelsDir = "res://scenes/levels/"

# counter starts at -1 to account for menu; each level is +1 to the index
var levelIndex = -1

func _ready() -> void:
	populateLevelList(levelsDir)

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
		print("An error occurred when trying to access the path.")
 
func levelSwitch():
	await DeathRect.fadeOut()
	levelIndex += 1
	
	if levelIndex > (levels.size() - 1):
		pass
	else:
		get_tree().change_scene_to_file(levels[levelIndex])
		DeathRect.fadeIn()
