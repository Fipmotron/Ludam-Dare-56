extends Node2D

@export var racoonEntity : PackedScene

@export var spawnTime =  30.0
var startSpawnTime = spawnTime

var poision = false
var plevel = 1

var knockback = false
var klevel = 1

var stun = false
var slevel = 1


var Can_Start = false

func _ready() -> void:
	SignalManager.connect("StartRacoon", Callable(self, "_Start"))
	SignalManager.connect("PoisionUpdater", Callable(self, "_Poision_Update"))
	SignalManager.connect("KnockbackUpdater", Callable(self, "_Knockback_Update"))
	SignalManager.connect("StunUpdater", Callable(self, "_Stun_Update"))

func _physics_process(delta: float) -> void:
	if Can_Start:
		if get_tree().get_node_count_in_group("Racoon") < 1 and spawnTime < 0.0:
			_Spawn()
		else:
			spawnTime -= delta

func _Spawn():
	var racoon = racoonEntity.instantiate()
	
	racoon.get_child(3).poison = poision
	racoon.get_child(3).poisonLevel = plevel
	
	racoon.get_child(3).knockback = knockback
	racoon.get_child(3).knockbackLevel = klevel
	
	racoon.get_child(3).stun = stun
	racoon.get_child(3).stunLevel = slevel
	
	var rng = randi_range(0, 1)
	
	match rng:
		1:
			racoon.direction = -1
		0:
			racoon.direction = 1
	
	racoon.global_position = get_child(rng).global_position
	racoon.add_to_group("Racoon")
	get_tree().root.get_child(1).add_child.call_deferred(racoon)
	
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
