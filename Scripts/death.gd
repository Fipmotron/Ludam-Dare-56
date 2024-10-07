extends AudioStreamPlayer2D


func _on_finished() -> void:
	get_tree().reload_current_scene()
	queue_free()
