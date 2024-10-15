class_name Falling
extends State

func enter_state() -> void:
	player.animation_player.play("fall")

func update(delta : float) -> State:
	player.do_gravity(delta)
	player.do_movement(delta)
	
	if (player.coyote_time && player.jump_just_pressed):
		print("Coyote jump")
		return states.Jumping

	if player.is_on_floor():
		return states.Idle
	elif player.attack_input:
		return states.Attacking
		
	return null
