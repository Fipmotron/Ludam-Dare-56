extends Control

func _ready() -> void:
	if FileAccess.file_exists("user://MasterSound.save"):
		var save = FileAccess.open("user://MasterSound.save", FileAccess.READ)
		var value = save.get_var()
		AudioServer.set_bus_volume_db(0, linear_to_db(value))
		$OptionsPanel/MasterSlider.value = value
		save.close()
	
	if FileAccess.file_exists("user://MusicSound.save"):
		var save = FileAccess.open("user://MusicSound.save", FileAccess.READ)
		var value = save.get_var()
		AudioServer.set_bus_volume_db(1, linear_to_db(value))
		$OptionsPanel/MusicSlider.value = value
		save.close()
	
	if FileAccess.file_exists("user://SFXSound.save"):
		var save = FileAccess.open("user://SFXSound.save", FileAccess.READ)
		var value = save.get_var()
		AudioServer.set_bus_volume_db(2, linear_to_db(value))
		$OptionsPanel/SFXSlider.value = value
		save.close()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and not get_tree().paused:
		visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		visible = false
		get_tree().paused = false

func _Resume():
	visible = false
	get_tree().paused = false

func _Options():
	$Menu.visible = false
	$OptionsPanel.visible = true

func _Options_Back():
	$Menu.visible = true
	$OptionsPanel.visible = false

func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	
	var save_file = FileAccess.open("user://MasterSound.save", FileAccess.WRITE)
	save_file.store_var(value)
	save_file.close()


func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	
	var save_file = FileAccess.open("user://MusicSound.save", FileAccess.WRITE)
	save_file.store_var(value)
	save_file.close()

func _on_SFX_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	
	var save_file = FileAccess.open("user://SFXSound.save", FileAccess.WRITE)
	save_file.store_var(value)
	save_file.close()

func _Quit():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
