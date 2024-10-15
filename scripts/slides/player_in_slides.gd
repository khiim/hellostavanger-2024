extends CharacterBody2D

const FALL_OFF_SCREEN = preload("res://scenes/effects/fall_off_screen.tscn")

signal died

signal slide_changed(slide_number : int)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var jump_audio_stream_player_2d: AudioStreamPlayer2D = $JumpAudioStreamPlayer2D

enum States { IDLE, RUNNING, JUMPING, FALLING }

@export var state : States = States.IDLE

@export var speed : float = 120.0
@export var jump_velocity : float = -320
@export var jump_gravity : float = 640
@export var fall_gravity : float = 1000
@export var max_fall_speed : float = 500.0

var current_slide = 0

var jumping = false

var movement_input : Vector2 = Vector2.ZERO
var jump_input : bool = false
var jump_just_pressed : bool = false

var dead : bool = false

func _ready() -> void:
	pass

func player_input() -> void:
	movement_input = Vector2.ZERO
	movement_input.x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		jump_just_pressed = true
	if Input.is_action_just_released("jump") && jump_just_pressed:
		jump_just_pressed = false

	jump_input = Input.is_action_pressed("jump")

func check_direction() -> void:
	if (movement_input.x < 0):
		sprite_2d.flip_h = true
		
	elif (movement_input.x > 0):
		sprite_2d.flip_h = false

func _physics_process(delta : float) -> void:
	player_input()
	check_direction()
	
	match state:
		States.IDLE:
			handle_idle(delta)
		States.RUNNING:
			handle_running(delta)
		States.JUMPING:
			handle_jumping(delta)
		States.FALLING:
			handle_falling(delta)
	
	calculate_slide()

func do_movement(_delta : float) -> void:
	if movement_input.x:
		velocity.x = movement_input.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func get_current_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity;

func do_gravity(delta : float) -> void:
	if not is_on_floor():
		velocity.y += get_current_gravity() * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

func handle_idle(delta : float) -> void:
	do_gravity(delta)
	do_movement(delta)

	if jump_just_pressed and is_on_floor():
		jump()
	elif velocity.y > 0:
		fall()
	elif !is_zero_approx(velocity.x):
		walk()

func handle_running(delta : float) -> void:
	do_gravity(delta)
	do_movement(delta)

	if jump_just_pressed and is_on_floor():
		jump()
	elif velocity.y > 0:
		fall()
	elif is_zero_approx(velocity.x):
		idle()

func handle_jumping(delta : float) -> void:
	do_gravity(delta)
	do_movement(delta)
	
	if jumping && !jump_input && velocity.y < 0:
		velocity.y = 0
		jumping = false
	
	if is_on_floor():
		jumping = false
		idle()
	elif velocity.y > 0:
		jumping = false
		fall()

func handle_falling(delta : float) -> void:
	do_gravity(delta)
	do_movement(delta)
	
	if is_on_floor():
		idle()

func jump():
	jump_just_pressed = false
	animation_player.play("jump")
	velocity.y = jump_velocity
	state = States.JUMPING
	jumping = true
	jump_audio_stream_player_2d.play()

func fall():		
	animation_player.play("fall")
	state = States.FALLING

func idle():
	animation_player.play("idle")
	state = States.IDLE

func walk():
	animation_player.play("run")
	state = States.RUNNING

func die() -> void:
	if dead: return
	dead = true
	var effect = FALL_OFF_SCREEN.instantiate()
	effect.init_from_sprite(sprite_2d)
	add_sibling(effect)
	died.emit()
	queue_free()

func calculate_slide() -> void:
	var slide_we_are_on := (int) (global_position.x / 320)
	if slide_we_are_on != current_slide:
		print("Changed to slide ", slide_we_are_on)
		current_slide = slide_we_are_on
		slide_changed.emit(current_slide)

func _on_box_detection_area_2d_body_entered(body: Node2D) -> void:
	if body is Box:
		body.jump_into_box()
