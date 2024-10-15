class_name Running
extends State

func enter_state() -> void:
	player.animation_player.play("run")

func update(delta : float) -> State:
	player.do_gravity(delta)
	player.do_movement(delta)
	
	if player.jump_just_pressed and player.is_on_floor():
		return states.Jumping
	elif player.velocity.y > 0:
		player.coyote_time = true
		print("Coyote time start")
		player.coyote_timer.start()
		return states.Falling
	elif player.attack_input:
		return states.Attacking
	elif is_zero_approx(player.velocity.x):
		return states.Idle
	
	return null
