extends Control

var Player

var score = 0.0
var localscore = 0.0

func _ready() -> void:
	Player = get_tree().get_first_node_in_group("Player")
	
	SignalManager.connect("Score_Update", Callable(self, "_Score_Updater"))

func _physics_process(delta: float) -> void:
	if Player != null:
		
		$HealthSlider.max_value = Player.healthComponent.maxHealth
		$HealthSlider.value = Player.healthComponent.health
	
	if get_tree().paused:
		visible = false
	else:
		visible = true

func _Score_Updater(num):
	if FileAccess.file_exists("user://Score.save"):
		var oldsave = FileAccess.open("user://Score.save", FileAccess.READ)
		score = oldsave.get_var()
		oldsave.close()
	
	score += num
	
	var savefile = FileAccess.open("user://Score.save", FileAccess.WRITE)
	savefile.store_var(score)
	savefile.close()
	
	localscore += num
	$Scorelabel.text = "SCORE:" + "%06d" % [localscore]
