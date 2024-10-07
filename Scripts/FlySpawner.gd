extends Node2D

@export var flyEntity : PackedScene

@export var spawnTime =  1.0
var startSpawnTime = spawnTime

var Can_Start = false

func _ready() -> void:
	SignalManager.connect("StartEnemies", Callable(self, "_Start"))

func _physics_process(delta: float) -> void:
	if Can_Start:
		if get_tree().get_node_count_in_group("Fly") < 3 and spawnTime < 0.0:
			_Spawn()
		else:
			spawnTime -= delta

func _Spawn():
	var fly = flyEntity.instantiate()
	
	var rng = randi_range(0, 3)
	
	match rng:
		0:
			fly.direction = 1
		1:
			fly.direction = 1
		2:
			fly.direction = -1
		3:
			fly.direction = -1
	
	fly.global_position = get_child(rng).global_position
	fly.add_to_group("Fly")
	get_tree().root.get_child(1).add_child.call_deferred(fly)
	
	spawnTime = startSpawnTime

func _Start():
	Can_Start = true
