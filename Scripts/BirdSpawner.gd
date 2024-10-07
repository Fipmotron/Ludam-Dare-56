extends Node2D

@export var birdEntity : PackedScene

@export var spawnTime =  7.0
var startSpawnTime = spawnTime

var poision = false
var plevel = 1

var knockback = false
var klevel = 1

var stun = false
var slevel = 1

var Can_Start = false

func _ready() -> void:
	SignalManager.connect("StartBird", Callable(self, "_Start"))

func _physics_process(delta: float) -> void:
	if Can_Start:
		if get_tree().get_node_count_in_group("Bird") < 2 and spawnTime < 0.0:
			_Spawn()
		else:
			spawnTime -= delta

func _Spawn():
	var bird = birdEntity.instantiate()
	
	bird.get_child(3).poison = poision
	bird.get_child(3).poisonLevel = plevel
	
	bird.get_child(3).knockback = knockback
	bird.get_child(3).knockbackLevel =klevel
	
	bird.get_child(3).stun = stun
	bird.get_child(3).stunLevel = slevel
	
	bird.global_position = global_position
	bird.add_to_group("Bird")
	get_tree().root.get_child(1).add_child.call_deferred(bird)
	
	spawnTime = startSpawnTime

func _Start():
	Can_Start = true
