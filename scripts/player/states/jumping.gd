class_name Jumping
extends State

func enter_state() -> void:
	player.jump_just_pressed = false
	player.animation_player.play("jump")
	player.jump_audio_stream_player_2d.play()
	player.velocity.y = player.jump_velocity
	player.jumping = true
	player.coyote_time = false
	
func exit_state() -> void:
	pass

func update(delta : float) -> State:
	player.do_gravity(delta)
	player.do_movement(delta)
	
	if player.jumping && !player.jump_input && player.velocity.y < 0:
		player.velocity.y = 0
		player.jumping = false
	
	if player.is_on_floor():
		player.jumping = false
		return states.Idle
	elif player.attack_input:
		player.jumping = false
		return states.Attacking
	elif player.velocity.y > 0:
		player.jumping = false
		return states.Falling

	return null
