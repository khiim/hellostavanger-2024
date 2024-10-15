extends AnimatedSprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.heal():
			queue_free()
