extends CharacterBody2D

@export var moveSpeed = 0.0
@export var direction = 0

@export var Gravity = 0.0

@onready var Hitbox = get_node("HitboxComponent")

var knockedBack = false

var knbLevel
var knbForce
var refPos

var canMove = true

func _physics_process(_delta: float) -> void:
	
	if direction > 0:
		$Polygon2D.scale.x = 1
	elif direction < 0 :
		$Polygon2D.scale.x = -1
	
	if canMove:
		$AnimationPlayer.play("Slither")
		velocity.x = moveSpeed * direction
	else:
		$AnimationPlayer.play("Stun")
	
	if knockedBack:
		var kbdirection = global_position - refPos
		velocity = kbdirection.normalized() * (knbForce * knbLevel)
		
	
	_Gravity()
	
	move_and_slide()

func _Gravity():
	velocity.y += Gravity

func _Knockback_Effect(kbLevel, kbForce, referancePos):
	knbLevel = kbLevel
	knbForce = kbForce
	refPos = referancePos
	
	knockedBack = true
	await get_tree().create_timer(0.25).timeout
	knockedBack = false
	velocity.x = 0.0

func _Stun_Effect(stunLevel, stunTime):
	canMove = false
	velocity.x = 0.0
	await get_tree().create_timer(stunLevel * stunTime).timeout
	canMove = true

func _Death_Handler():
	queue_free()

func _Hit_SFX():
	$SFX/HitSFX.play()

func _Slither_SFX():
	$SFX/SlitherSFX.play()
