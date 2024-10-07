extends CharacterBody2D

@export var flySpeed = 0.0

@export var landingBounds : Vector2

@export var groundedTime = 0.0
var grounded = true

var knockedBack = false

var knbLevel
var knbForce
var refPos

var canMove = true

func _ready() -> void:
	global_position.x = randi_range(landingBounds.x, landingBounds.y)
	

func _physics_process(delta: float) -> void:
	if grounded and not is_on_floor():
		$AnimationPlayer.play("Flydown")
		
		$SFX/BirdFlySFX.play()
		
		velocity.y += flySpeed 
	elif grounded and is_on_floor():
		if canMove:
			groundedTime -= delta
			
			$AnimationPlayer.play("Grounded")
			
			if groundedTime <= 0.0:
				grounded = false
		else:
			$AnimationPlayer.play("Stun")
		
		velocity.y += flySpeed
	
	if not grounded:
		velocity.y -= flySpeed
		
		$SFX/BirdFlySFX.play()
		
		$AnimationPlayer.play("FlyUp")
	
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

func _Death_Handler():
	queue_free()

func _Hit_SFX():
	$SFX/HitSFX.play()
