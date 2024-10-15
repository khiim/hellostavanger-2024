extends CharacterBody2D

const FALL_OFF_SCREEN = preload("res://scenes/effects/fall_off_screen.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var patrol_radius : float = 50
@export var patrol_speed : float = 25
@export var attack_speed : float = 200

var starting_position : Vector2
var current_target : Vector2

var player : Player

enum States { PATROL, ATTACK }

var state : States = States.PATROL
var attack_cooldown : bool = false

func _ready() -> void:
	starting_position = global_position
	aquire_new_target()

func _physics_process(_delta: float) -> void:
	if attack_cooldown:
		handle_patrol()
		return
	
	match state:
		States.PATROL:
			handle_patrol()
		States.ATTACK:
			handle_attacking()

func handle_patrol() -> void:
	if !attack_cooldown && player:
		start_attacking()
		return
	
	if (global_position - current_target).length_squared() < 16:
		aquire_new_target()
	
	velocity = global_position.direction_to(current_target).normalized() * patrol_speed
	move_and_slide()

func handle_attacking() -> void:
	if !player || attack_cooldown:
		stop_attacking()
		return
	
	var center_of_player = player.global_position + Vector2(0, -16)
	
	velocity = global_position.direction_to(center_of_player).normalized() * attack_speed
	move_and_slide()

func aquire_new_target() -> void:
	var angle = randf_range(-PI, PI)
	var direction = Vector2.RIGHT.rotated(angle)
	current_target = starting_position + direction * randf_range(0, patrol_radius)

func start_attacking() -> void:
	animated_sprite_2d.play("attack")
	state = States.ATTACK

func stop_attacking() -> void:
	animated_sprite_2d.play("patrol")
	state = States.PATROL


func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body


func _on_detection_area_2d_body_exited(_body: Node2D) -> void:
	player = null


func _on_timer_timeout() -> void:
	attack_cooldown = false


func _on_hit_box_component_hit(_hurtbox: HurtBoxComponent) -> void:
	attack_cooldown = true
	stop_attacking()
	aquire_new_target()
	timer.start()


func _on_hurt_box_component_hurt(_damage: int) -> void:
	var effect = FALL_OFF_SCREEN.instantiate()
	effect.init_from_animated_sprite(animated_sprite_2d)
	add_sibling(effect)
	queue_free()
