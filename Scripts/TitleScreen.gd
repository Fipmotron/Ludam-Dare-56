extends Node2D

var upgradeSavePath = "user://upgrades.save"
var upgradeArray = [0, 0, 0, 0, 0, 0]

var coinSavePath = "user://coins.save"
var coins

var poisonLevel = 0
var knockbackLevel = 0
var stunLevel = 0
var healthLevel = 0
var jumpLevel = 0
var tongueLevel = 0

func _ready() -> void:
	if FileAccess.file_exists(coinSavePath):
		var savefile = FileAccess.open(coinSavePath, FileAccess.READ)
		coins = savefile.get_var()
		savefile.close()
	elif not FileAccess.file_exists(coinSavePath):
		coins = 0
	
	$ShopPanel/Coinlabel.text = "COINS: " + str(coins)
	
	if FileAccess.file_exists(upgradeSavePath):
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.READ)
		var extra = savefile.get_line()
		var upgrades = JSON.parse_string(extra)
		savefile.close()
		
		for i in upgrades:
			upgradeArray = upgrades
	
	poisonLevel = upgradeArray[0]
	knockbackLevel = upgradeArray[1]
	stunLevel = upgradeArray[2]
	healthLevel = upgradeArray[3]
	jumpLevel = upgradeArray[4]
	tongueLevel = upgradeArray[5]
	
	print(upgradeArray)
	
	if poisonLevel == 5:
		$ShopPanel/PoisonButton.disabled = true
	if knockbackLevel == 5:
		$ShopPanel/KnockbackButton.disabled = true
	if stunLevel == 5:
		$ShopPanel/StunButton.disabled = true
	if healthLevel == 5:
		$ShopPanel/HealthButton.disabled = true
	if jumpLevel == 5:
		$ShopPanel/JumpButton.disabled = true
	if tongueLevel == 5:
		$ShopPanel/TongueButton.disabled = true
	
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
	
	
	if FileAccess.file_exists("user://Score.save"):
		var save = FileAccess.open("user://Score.save", FileAccess.READ)
		var value = save.get_var()
		$TitlePanel/ScoreLabel.text = "TOTAL SCORE:" + "%06d" % [value]
		save.close()

func _Start_Game():
	get_tree().change_scene_to_file("res://Scenes/GameScene.tscn")

func _Shop():
	_Button_SFX()
	
	var atween = get_tree().create_tween()
	atween.tween_property($ShopPanel, "global_position", Vector2(-480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	var btween = get_tree().create_tween()
	btween.tween_property($TitlePanel, "global_position", Vector2(-480, -816), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func _Buy_Poison():
	_Button_SFX()
	
	var cost = 0
	
	if 5*poisonLevel == 0:
		cost = 5
	else:
		cost = 5*poisonLevel
	
	if coins >= cost:
		if poisonLevel < 5:
			poisonLevel += 1
		
		if poisonLevel == 5:
			$ShopPanel/PoisonButton.disabled = true
		
		upgradeArray[0] = poisonLevel
		
		_Bought(cost)
		
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
		var json_string = JSON.stringify(upgradeArray)
		savefile.store_line(json_string)
		savefile.close()
	else:
		print("NOT ENOUGH")

func _Buy_Knockback():
	_Button_SFX()
	
	var cost = 0
	
	if 5*knockbackLevel == 0:
		cost = 5
	else:
		cost = 5*knockbackLevel
	
	if coins >= cost:
		if knockbackLevel < 5:
			knockbackLevel += 1
		if knockbackLevel == 5:
			$ShopPanel/KnockbackButton.disabled = true
		
		upgradeArray[1] = knockbackLevel
		
		_Bought(cost)
		
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
		var json_string = JSON.stringify(upgradeArray)
		savefile.store_line(json_string)
		savefile.close()
	else:
		print("NOT ENOUGH")

func _Buy_Stun():
	_Button_SFX()
	
	var cost = 0
	
	if 5*stunLevel == 0:
		cost = 5
	else:
		cost = 5*stunLevel
	
	if coins >= cost:
		if stunLevel < 5:
			stunLevel += 1
		if stunLevel == 5:
			$ShopPanel/StunButton.disabled = true
		
		upgradeArray[2] = stunLevel
		
		_Bought(cost)
		
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
		var json_string = JSON.stringify(upgradeArray)
		savefile.store_line(json_string)
		savefile.close()
	else:
		print("NOT ENOUGH")

func _Buy_Health():
	_Button_SFX()
	
	var cost = 0
	
	if 5*healthLevel == 0:
		cost = 5
	else:
		cost = 5*healthLevel
	
	if coins >= cost:
		if healthLevel < 5:
			healthLevel += 1
		if healthLevel == 5:
			$ShopPanel/HealthButton.disabled = true
		
		upgradeArray[3] = healthLevel
		
		_Bought(cost)
		
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
		var json_string = JSON.stringify(upgradeArray)
		savefile.store_line(json_string)
		savefile.close()
	else:
		print("NOT ENOUGH")

func _Buy_Jump():
	_Button_SFX()
	
	var cost = 0
	
	if 5*healthLevel == 0:
		cost = 5
	else:
		cost = 5*healthLevel
	
	if coins >= cost:
		if jumpLevel < 5:
			jumpLevel += 1
		if jumpLevel == 5:
			$ShopPanel/JumpButton.disabled = true
		
		upgradeArray[4] = jumpLevel
		
		_Bought(cost)
		
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
		var json_string = JSON.stringify(upgradeArray)
		savefile.store_line(json_string)
		savefile.close()
	else:
		print("NOT ENOUGH")

func _Buy_Tongue():
	_Button_SFX()
	
	var cost = 0
	
	if 5*healthLevel == 0:
		cost = 5
	else:
		cost = 5*healthLevel
	
	if coins >= cost:
		if tongueLevel < 5:
			tongueLevel += 1
		if tongueLevel == 5:
			$ShopPanel/TongueButton.disabled = true
		
		upgradeArray[5] = tongueLevel
		
		_Bought(cost)
		
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.WRITE)
		var json_string = JSON.stringify(upgradeArray)
		savefile.store_line(json_string)
		savefile.close()
	else:
		print("NOT ENOUGH")

func _Bought(cost):
	coins -= cost
	
	if FileAccess.file_exists(coinSavePath):
		var savefile = FileAccess.open(coinSavePath, FileAccess.WRITE)
		savefile.store_var(coins)
		savefile.close()
	
	$ShopPanel/Coinlabel.text = "COINS: " + str(coins)

func _Shop_Back():
	_Button_SFX()
	
	var atween = get_tree().create_tween()
	atween.tween_property($ShopPanel, "global_position", Vector2(-1440, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	var btween = get_tree().create_tween()
	btween.tween_property($TitlePanel, "global_position", Vector2(-480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func _Options():
	_Button_SFX()
	
	var atween = get_tree().create_tween()
	atween.tween_property($OptionsPanel, "global_position", Vector2(-480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	var btween = get_tree().create_tween()
	btween.tween_property($TitlePanel, "global_position", Vector2(-480, -816), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func _Options_Back():
	_Button_SFX()
	
	var atween = get_tree().create_tween()
	atween.tween_property($OptionsPanel, "global_position", Vector2(480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	var btween = get_tree().create_tween()
	btween.tween_property($TitlePanel, "global_position", Vector2(-480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func _Exit():
	_Button_SFX()
	
	var atween = get_tree().create_tween()
	atween.tween_property($QuitPanel, "global_position", Vector2(-480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	var btween = get_tree().create_tween()
	btween.tween_property($TitlePanel, "global_position", Vector2(-480, -816), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func _Exit_Return():
	_Button_SFX()
	
	var atween = get_tree().create_tween()
	atween.tween_property($QuitPanel, "global_position", Vector2(-480, 272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	var btween = get_tree().create_tween()
	btween.tween_property($TitlePanel, "global_position", Vector2(-480, -272), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func _Button_SFX():
	$ButtonSFX.play()

func _Quit_Game():
	get_tree().quit()

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
