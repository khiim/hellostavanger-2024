class_name Idle
extends State

func enter_state() -> void:
	player.animation_player.play("idle")

func update(delta : float) -> State:
	player.do_gravity(delta)
	player.do_movement(delta)

	if player.jump_just_pressed and player.is_on_floor():
		return states.Jumping
	elif player.velocity.y > 0:
		return states.Falling
	elif player.attack_input:
		return states.Attacking
	elif !is_zero_approx(player.velocity.x):
		return states.Running
	return null
