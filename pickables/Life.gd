extends Area2D

signal health_up

func _on_Life_body_entered(body):
	print(body.name)
	if body.name == "Player":
		emit_signal("health_up")
		get_tree().queue_delete(self)
