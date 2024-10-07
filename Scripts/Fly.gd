extends CharacterBody2D

@export var poisonPlayer = false

@export var moveSpeed = 100.0
@export var direction = 0

var tonugePath
var attachToTonuge = false

func _physics_process(_delta: float) -> void:
	if attachToTonuge:
		global_position = tonugePath.global_position
	else:
		velocity.x = direction * moveSpeed
	
	if direction > 0:
		$Polygon2D.scale.x = 1
	elif direction < 0 :
		$Polygon2D.scale.x = -1
	
	$AnimationPlayer.play("fly")
	
	move_and_slide()

func _Area_Entered(area: Area2D) -> void:
	tonugePath = area
	attachToTonuge = true

func _Eaten_Checker(_area: Area2D) -> void:
	if poisonPlayer:
		get_tree().get_first_node_in_group("Player").healthComponent.damageOverTime = true
		get_tree().get_first_node_in_group("Player").healthComponent.dotDamage = 2.0
		get_tree().get_first_node_in_group("Player").healthComponent.dotTime = 3.0
	
	SignalManager.emit_signal("Coin_Update")
	$SFX/FlyeatSFX.play()
	
	queue_free()
