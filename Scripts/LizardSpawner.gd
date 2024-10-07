extends Node2D

@export var lizardEntity : PackedScene

@export var spawnTime =  3.0
var startSpawnTime = spawnTime

var poision = false
var plevel = 1

var knockback = false
var klevel = 1

var stun = false
var slevel = 1


var Can_Start = false

func _ready() -> void:
	SignalManager.connect("StartEnemies", Callable(self, "_Start"))
	SignalManager.connect("PoisionUpdater", Callable(self, "_Poision_Update"))
	SignalManager.connect("KnockbackUpdater", Callable(self, "_Knockback_Update"))
	SignalManager.connect("StunUpdater", Callable(self, "_Stun_Update"))

func _physics_process(delta: float) -> void:
	if Can_Start:
		if get_tree().get_node_count_in_group("Lizard") < 6 and spawnTime < 0.0:
			_Spawn()
		else:
			spawnTime -= delta

func _Spawn():
	var lizard = lizardEntity.instantiate()
	
	lizard.get_child(3).poison = poision
	lizard.get_child(3).poisonLevel = plevel
	
	lizard.get_child(3).knockback = knockback
	lizard.get_child(3).knockbackLevel =klevel
	
	lizard.get_child(3).stun = stun
	lizard.get_child(3).stunLevel = slevel
	
	var rng = randi_range(0, 5)
	
	match rng:
		1:
			lizard.direction = -1
		2:
			lizard.direction = -1
		3:
			lizard.direction = 1
		4:
			lizard.direction = 1
		5:
			lizard.direction = -1
		0:
			lizard.direction = 1
	
	lizard.global_position = get_child(rng).global_position
	lizard.add_to_group("Lizard")
	get_tree().root.get_child(1).add_child.call_deferred(lizard)
	
	spawnTime = startSpawnTime

func _Start():
	Can_Start = true

func _Poision_Update(hasit, level):
	poision = hasit
	plevel = level

func _Knockback_Update(hasit, level):
	knockback = hasit
	klevel = level

func _Stun_Update(hasit, level):
	stun = hasit
	slevel = level
