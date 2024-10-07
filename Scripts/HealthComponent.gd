extends Area2D

@export var Parent : Node2D

@export var maxHealth : float
var health

@export var score = 1000

@export var deathParticles : PackedScene
@export var poisonParticles : PackedScene

var damageOverTime = false
var dotTime : float
var dotDamage : float
var dotInterval = 1.0

signal knockbackSignal
signal stunSignal
signal deathSignal

func _ready() -> void:
	health = maxHealth
	print(health)
	
	if Parent != null:
		knockbackSignal.connect(Callable(Parent, "_Knockback_Effect"))
		stunSignal.connect(Callable(Parent, "_Stun_Effect"))
		deathSignal.connect(Callable(Parent, "_Death_Handler"))

func _physics_process(delta: float) -> void:
	if damageOverTime:
		dotTime -= delta
		dotInterval -= delta
		
		if dotInterval <= 0.0:
			var parti = poisonParticles.instantiate()
			parti.emitting = true
			parti.global_position = global_position
			get_tree().root.get_child(0).add_child(parti)
			
			dotInterval = 1.0
			health -= dotDamage
			$FlashPlayer.play("Flash")
			Parent._Hit_SFX()
		
		if dotTime <= 0.0:
			damageOverTime = false
	
	if health <= 0.0:
		SignalManager.emit_signal("Score_Update", score)
		
		var parti = deathParticles.instantiate()
		parti.emitting = true
		parti.global_position = global_position
		get_tree().root.get_child(0).add_child(parti)
		
		emit_signal("deathSignal")

func _Area_Entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if area.poison and area.poisonLevel > 0:
			damageOverTime = true
			dotDamage = area.poisonDamage * area.poisonLevel
			dotTime = area.posionTime * area.poisonLevel
		
		if area.stun and area.stunLevel > 0:
			emit_signal("stunSignal", area.stunLevel, area.stunTime)
		
		if area.knockback and area.knockbackLevel > 0:
			emit_signal("knockbackSignal", area.knockbackLevel, area.knockbackForce, area.global_position)
		
		$FlashPlayer.play("Flash")
		Parent._Hit_SFX()
		
		health -= area.damage
		
		print("Hit", area.get_parent())
