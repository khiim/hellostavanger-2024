extends Sprite2D

@export var speed = 100

var velocity : Vector2

func target_player(from : Vector2, to : Vector2) -> void:
	global_position = from
	look_at(to)
	velocity = Vector2.RIGHT.rotated(rotation) * speed

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_hit_box_component_hit(hurtbox: HurtBoxComponent) -> void:
	hurtbox.deal_damage(1)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
