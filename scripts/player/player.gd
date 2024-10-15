class_name Player
extends CharacterBody2D

const FALL_OFF_SCREEN = preload("res://scenes/effects/fall_off_screen.tscn")
const RUBBER_DUCK = preload("res://scenes/weapons/weapon1/rubber_duck.tscn")

signal died
signal coffee_changed(coffee : int)

@onready var state_machine: StateMachine = $StateMachine
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var jump_audio_stream_player_2d: AudioStreamPlayer2D = $JumpAudioStreamPlayer2D
@onready var hurt_audio_stream_player_2d: AudioStreamPlayer2D = $HurtAudioStreamPlayer2D


#region State

var jumping : bool = false
var dead : bool = false
var facing : int = 1

#endregion

func _ready() -> void:
	if _camera:
		$RemoteTransform2D.remote_path = _camera.get_path()
	coffee_changed.emit(health_component.health)


func _physics_process(delta : float) -> void:
	player_input()
	check_direction()
	
	state_machine.update(delta)

var _camera : Camera2D
func set_camera(level_camera : Camera2D):
	_camera = level_camera

#region Player input

var direction_input : float = 0
var jump_input : bool = false
var jump_just_pressed : bool = false
var coyote_time : bool = false
var attack_input : bool = false
var fire_input : bool = false
var aim_input : bool = false

func player_input() -> void:
	direction_input = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		print("Jump Input pressed")
		jump_just_pressed = true
	if Input.is_action_just_released("jump") && jump_just_pressed:
		print("Jump Input released without jumping")
		jump_just_pressed = false

	jump_input = Input.is_action_pressed("jump")
	attack_input = Input.is_action_just_pressed("attack")
	fire_input = Input.is_action_pressed("fire")
	aim_input = Input.is_action_pressed("aim")

#endregion

#region Movement

@export var speed : float = 120.0
@export var jump_velocity : float = -320
@export var jump_gravity : float = 640
@export var fall_gravity : float = 1000
@export var max_fall_speed : float = 500.0

func check_direction() -> void:
	if (direction_input < 0):
		facing = -1
	elif (direction_input > 0):
		facing = 1
	update_sprite_direction()
		
func update_sprite_direction():
	sprite_2d.flip_h = facing < 0

func do_movement(_delta : float) -> void:
	if direction_input:
		velocity.x = direction_input * speed
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
#endregion

#region Actions

func hurt(damage: int) -> void:
	health_component.health -= damage
	hurt_audio_stream_player_2d.play()
	if health_component.health > 0:
		var tween: Tween = create_tween()
		tween.tween_property(sprite_2d, "modulate:r", 1, 0.25).from(15)

func die() -> void:
	if dead: return
	dead = true
	var effect = FALL_OFF_SCREEN.instantiate()
	effect.init_from_sprite(sprite_2d)
	add_sibling(effect)
	died.emit()
	queue_free()

func heal() -> bool:
	if health_component.health < health_component.max_health:
		health_component.health += 1
		return true
	return false

#endregion

#region Event handlers

func _on_hurt_box_component_hurt(damage: int) -> void:
	hurt(damage)

func _on_health_component_died() -> void:
	die()

func _on_health_component_health_changed(new_health: int, _previous_health: int) -> void:
	coffee_changed.emit(new_health)

func _on_coyote_timer_timeout() -> void:
	if coyote_time: print("Coyote timeout")
	coyote_time = false
#endregion
