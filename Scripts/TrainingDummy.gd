extends CharacterBody2D

var knockedBack = false

var knbLevel
var knbForce
var refPos

var canMove = true

func _physics_process(delta: float) -> void:
	
	if canMove:
		velocity.x = -500 * delta
	
	if knockedBack:
		var direction = global_position - refPos
		velocity = direction.normalized() * (knbForce * knbLevel)
		
	
	move_and_slide()

func _Knockback_Effect(kbLevel, kbForce, referancePos):
	knbLevel = kbLevel
	knbForce = kbForce
	refPos = referancePos
	
	knockedBack = true
	await get_tree().create_timer(0.25).timeout
	knockedBack = false
	velocity = Vector2.ZERO

func _Stun_Effect(stunLevel, stunTime):
	canMove = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(stunLevel * stunTime).timeout
	canMove = true
