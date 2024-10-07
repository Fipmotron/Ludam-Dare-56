extends CharacterBody2D

@export_category("Movement")
@export var moveSpeed = 0.0

@export var termVelocity = 0.0
@export var gravity = 0.0
@export var jumpForce = 0.0
@export var maxJumps = 0
var numJumps = maxJumps

@export var toonTime = 0.2
var startToonTime = toonTime

@export var jumpBuffer = 0.1
var startJumpBuffer = jumpBuffer

@export var walkPart : PackedScene

@export_category("Attacking")
@onready var tonugeLine = get_node("TonugeLine")
@onready var tonuge = get_node("TonugeLine/Tonuge")
@onready var Hitbox = get_node("TonugeLine/Tonuge/HitboxComponent")

@export var tonugeLength = 0.0

@export_category("Health")
@onready var healthComponent = get_node("HealthComponent")
@export var deathSFX : PackedScene


var knockedBack = false

var knbLevel
var knbForce
var refPos

var canMove = true


func _ready() -> void:
	jumpBuffer = 0.0
	
	SignalManager.connect("Hitbox_Update", Callable(self, "_Update_Hitbox"))
	print("CONNECT")

func _physics_process(delta: float) -> void:
	if canMove:
		_Horizontal_Movement()
		_Jump_Input(delta)
		_Drop_Down()
		_Tonuge_Input()
	
	#material.set("shader_parameter/rbg", Color.WHITE) 
	
	if not canMove:
		$AnimationPlayer.play("Stun")
	elif not is_on_floor():
		$AnimationPlayer.play("InAir")
	elif velocity.x != 0.0:
		$AnimationPlayer.play("Run")
	else:
		$AnimationPlayer.play("Idle")
	
	_Add_Gravity()
	
	move_and_slide()

func _Horizontal_Movement():
	var direction = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left")
	
	if direction > 0:
		$Polygon2D.flip_h = false
	elif direction < 0:
		$Polygon2D.flip_h = true
	
	velocity.x = direction * moveSpeed

func _Add_Gravity():
	velocity.y += gravity
	
	velocity.y = clamp(velocity.y, -termVelocity, termVelocity)

func _Jump_Input(delta):
	if is_on_floor():
		numJumps = maxJumps
		toonTime = startToonTime
	else:
		toonTime -= delta
	
	if Input.is_action_just_pressed("Jump"):
		jumpBuffer = startJumpBuffer
	
	if jumpBuffer > 0.0 and toonTime > 0.0 or numJumps > 0 and jumpBuffer > 0.0:
		velocity.y = -jumpForce
		numJumps -= 1
		$SFX/FrogJumpSFX.play()
		jumpBuffer = 0.0

func _Drop_Down():
	if Input.is_action_just_pressed("Drop_Down"):
		global_position.y += 1


func _Tonuge_Input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var playerPos = get_tree().get_first_node_in_group("Player").global_position
		var mousePos = get_global_mouse_position()
		var mouseDir = (mousePos-playerPos).normalized()
		var dist = playerPos.distance_to(mousePos)
		
		if dist > tonugeLength:
			var tween = get_tree().create_tween()
			tween.tween_property(tonuge, "global_position", playerPos + (mouseDir * tonugeLength), 0.1)
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(tonuge, "global_position", mousePos, 0.1)
			tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tonuge.position = lerp(tonuge.position, Vector2.ZERO, 0.1)
	
	tonugeLine.set_point_position(1, tonuge.position)

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

func _Update_Hitbox(upgrades):
	print("Updated!")
	
	Hitbox.poisonLevel = upgrades[0] 
	Hitbox.knockbackLevel = upgrades[1] 
	Hitbox.stunLevel = upgrades[2] 
	
	if upgrades[3] == 0:
		pass
	else:
		healthComponent.maxHealth = upgrades[3] * healthComponent.maxHealth
	
	healthComponent.health = healthComponent.maxHealth
	
	if upgrades[4] == 0:
		pass
	else:
		maxJumps = upgrades[4] + 1
	
	if upgrades[5] == 0:
		pass
	else:
		tonugeLength = upgrades[5] * tonugeLength

func _Death_Handler():
	queue_free()
	
	var sfx = deathSFX.instantiate()
	get_tree().root.get_child(1).add_child(sfx)
	sfx.play()

func _Walk_SFX():
	$SFX/FrogGrassWalkSFX.play()

func _Hit_SFX():
	$SFX/FrogHitSFX.play()

func _Fly_SFX(_area : Area2D):
	$SFX/FlyeatSFX.play()

func _Walk_Particle():
	var parti = walkPart.instantiate()
	parti.emitting = true
	parti.global_position = Vector2(global_position.x, global_position.y + 16)
	get_tree().root.get_child(1).add_child(parti)
