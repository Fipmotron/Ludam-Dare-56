extends Node2D

@export var fireflyEntity : PackedScene

@export var spawnTime =  1.5
var startSpawnTime = spawnTime

var Can_Start = false

func _ready() -> void:
	SignalManager.connect("StartEnemies", Callable(self, "_Start"))

func _physics_process(delta: float) -> void:
	if Can_Start:
		if get_tree().get_node_count_in_group("FireFly") < 6 and spawnTime < 0.0:
			_Spawn()
		else:
			spawnTime -= delta

func _Spawn():
	var fly = fireflyEntity.instantiate()
	
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
	fly.add_to_group("FireFly")
	get_tree().root.get_child(1).add_child.call_deferred(fly)
	
	spawnTime = startSpawnTime

func _Start():
	Can_Start = true
