extends CharacterBody2D

@export var moveSpeed = 0.0
@export var gravity = 0.0
@export var direction = 0


var knockedBack = false

var knbLevel
var knbForce
var refPos

var canMove = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if canMove:
		velocity.x = direction * moveSpeed
		
		if direction > 0:
			$Polygon2D.scale.x = 1
		elif direction < 0 :
			$Polygon2D.scale.x = -1
		
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("Stun")
	
	if knockedBack:
		var direction = global_position - refPos
		velocity = direction.normalized() * (knbForce * knbLevel)
	
	velocity.y += gravity
	
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

func _Death_Handler():
	queue_free()

func _Hit_SFX():
	$SFX/HitSFX.play()

func _Thud_SFX():
	$SFX/AnimalThumpSFX.play()
