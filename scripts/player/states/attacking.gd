class_name Attacking
extends State

@export var animation_player : AnimationPlayer
@export var hit_box : HitBoxComponent

func _ready() -> void:
	if animation_player == null: push_error("Missing animation player in Attacking state")
	if hit_box == null: push_error("Missing hitbox for Attack state")
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func enter_state() -> void:
	player.animation_player.play("attack")

func update(delta : float) -> State:
	hit_box.scale.x = player.facing
	player.do_gravity(delta)
	if player.is_on_floor():
		player.velocity.x = 0
	player.move_and_slide()
	
	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		if player.is_on_floor():
			state_machine.change_state(states.Idle)
		else:
			if player.velocity.y < 0: player.velocity.y = 0
			state_machine.change_state(states.Falling)
