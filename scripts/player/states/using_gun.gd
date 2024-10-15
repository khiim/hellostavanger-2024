class_name UsingGun
extends State

@export var gun : Gun

func _ready() -> void:
	if gun == null: push_error("Missing gun for UsingGun state")

func enter_state() -> void:
	gun.equipped = true
	player.animation_player.play("gun")
	
func exit_state() -> void:
	gun.equipped = false
	gun.update_visibility_and_aim(0)

func update(_delta : float) -> State:
	var mouse_pos = gun.get_global_mouse_position()
	var gun_pos = gun.global_position
	
	player.facing = -1 if mouse_pos.x < gun_pos.x else 1
	player.update_sprite_direction()
	
	if player.fire_input:
		if !gun.firing:
			gun.start_firing()
	else:
		if gun.firing:
			gun.stop_firing()
	
	gun.facing = player.facing
	var aim = 0
	if player.aim_input:
		aim = gun.calculate_angle_to_position(mouse_pos)
	gun.update_visibility_and_aim(aim)
	
	return null

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("2"): return
	
	if state_machine.is_in_state(states.Idle):
		state_machine.change_state(states.UsingGun)
	elif state_machine.is_in_state(self):
		state_machine.change_state(states.Idle)
