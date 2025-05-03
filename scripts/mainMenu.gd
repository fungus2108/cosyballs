extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DeathRect.fadeIn()
	
	# the gumdrop buttons
	$menuItems/playPanel/playButton.pressed.connect(playButton)
	$menuItems/optionsPanel/optionsButton.pressed.connect(optionsButton)
	$menuItems/creditsPanel/creditsButton.pressed.connect(creditsButton)
	$menuItems/quitPanel/quitButton.pressed.connect(quitButton)
	
	# probably could combine them but im giga lazy
	$creditItems/creditBackPanel/creditBackButton.pressed.connect(creditsBackButton)
	$optionsItems/optionsBackPanel/optionsBackButton.pressed.connect(optionsBackButton)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		if $menuItems.visible == true:
			get_tree().quit()
		else: 
			$menuItems.visible = true
			$creditItems.visible = false
			$optionsItems.visible = false
	
	# volume slider
	$optionsItems/volumePanel/Label.text = "Volume: " + str($optionsItems/volumePanel/volumeSlider.value * 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($optionsItems/volumePanel/volumeSlider.value))
	
func playButton():
	LevelManager.levelSwitch()
	
func optionsButton():
	$menuItems.visible = false
	$optionsItems.visible = true
	
func creditsButton():
	$menuItems.visible = false
	$creditItems.visible = true
	
func quitButton():
	get_tree().quit()

func creditsBackButton():
	$creditItems.visible = false
	$menuItems.visible = true

func optionsBackButton():
	$optionsItems.visible = false
	$menuItems.visible = true
