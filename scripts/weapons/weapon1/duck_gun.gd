extends Marker2D

const RUBBER_DUCK = preload("res://scenes/weapons/weapon1/rubber_duck.tscn")

@export var player : Player	

func _input(event: InputEvent) -> void:
	if player && player.state_machine.is_in_state_named("UsingGun"): return
	if event.is_action_pressed("fire"): fire_rubber_duck()

func fire_rubber_duck() -> void:
	var direction = (get_global_mouse_position() - global_position).normalized()
	var spawn = global_position + (direction * 30)
	var duck = RUBBER_DUCK.instantiate()
	duck.global_position = spawn
	duck.apply_central_force(direction * 1500)
	Effects.add_effect(duck)
