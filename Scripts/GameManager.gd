extends Node2D

var global_timer = 0.0
var timer = 0.0

var hasPoison = false
var poisonLevel = 1

var hasKnockback = false
var knockbackLevel = 1

var hasStun = false
var stunLevel = 1

var upgradeSavePath = "user://upgrades.save"
var coinSavePath = "user://coins.save"

func _ready() -> void:
	if FileAccess.file_exists(upgradeSavePath):
		var savefile = FileAccess.open(upgradeSavePath, FileAccess.READ)
		var extra = savefile.get_line()
		var upgrades = JSON.parse_string(extra)
		savefile.close()
		
		await get_tree().create_timer(0.1).timeout
		SignalManager.emit_signal("Hitbox_Update", upgrades)
	
	SignalManager.connect("Coin_Update", Callable(self, "_Coin_Storage"))

func _physics_process(delta: float) -> void:
	global_timer += delta
	
	timer += delta
	
	if global_timer > 5.0 and global_timer < 6.0:
		SignalManager.emit_signal("StartEnemies")
	
	if global_timer > 35.0 and global_timer < 36.0:
		SignalManager.emit_signal("StartBird")
	
	if global_timer > 60.0 and global_timer < 61.0:
		SignalManager.emit_signal("StartRacoon")
	
	if timer >= 30.0:
		var rng = randi_range(1, 3)
		
		match rng:
			1:
				if not hasPoison:
					hasPoison = true
				else:
					if poisonLevel == 5:
						pass
					else:
						poisonLevel += 1
			2:
				if not hasKnockback:
					hasKnockback = true
				else:
					if knockbackLevel == 5:
						pass
					else:
						knockbackLevel += 1
			3:
				if not hasStun:
					hasStun = true
				else:
					if stunLevel == 5:
						pass
					else:
						stunLevel += 1
		
		SignalManager.emit_signal("PoisionUpdater", hasPoison, poisonLevel)
		SignalManager.emit_signal("KnockbackUpdater", hasKnockback, knockbackLevel)
		SignalManager.emit_signal("StunUpdater", hasStun, stunLevel)
	

func _Coin_Storage():
	var coins = 0
	
	$FlyeatSFX.play()
	$FrogCoinSFX.play()
	
	if not FileAccess.file_exists(coinSavePath):
		var savefile = FileAccess.open(coinSavePath, FileAccess.WRITE)
		savefile.store_var(coins)
		savefile.close()
	
	if FileAccess.file_exists(coinSavePath):
		var savefileone = FileAccess.open(coinSavePath, FileAccess.READ)
		var oldcoins = savefileone.get_var()
		oldcoins += 1
		savefileone.close()
		
		var savefiletwo = FileAccess.open(coinSavePath, FileAccess.WRITE)
		savefiletwo.store_var(oldcoins)
		savefiletwo.close()
