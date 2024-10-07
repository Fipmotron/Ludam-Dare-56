extends Area2D

func _Body_Entered(body: Node2D) -> void:
	body.queue_free()
