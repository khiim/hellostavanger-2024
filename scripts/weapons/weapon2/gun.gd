class_name Gun
extends Node2D

const HIT_EFFECT = preload("res://scenes/effects/hit_effect.tscn")

@export var back_arm : Node2D

@export var cooldown_period : int = 5
@export var damage : int = 10

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = %RayCast2D
@onready var tracer_line: Line2D = %TracerLine
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var fire_audio_stream_player_2d: AudioStreamPlayer2D = $FireAudioStreamPlayer2D

var equipped : bool = false:
	set(value):
		if firing:
			stop_firing()
		equipped = value

var firing : bool = false
var facing : int = 1

var cooldown : int = 0
var should_show_tracer_line : bool = true

func _ready() -> void:
	if !back_arm: push_error("Missing reference to BackArm in Gun node")
	visible = equipped
	tracer_line.visible = false

func _physics_process(_delta: float) -> void:
	if firing: handle_firing()

func update_visibility_and_aim(angle : float) -> void:
	visible = equipped
	scale.x = facing
	animated_sprite_2d.rotation = angle
	if back_arm:
		back_arm.visible = equipped
		back_arm.scale.x = facing
		back_arm.get_child(0).rotation = angle

func calculate_angle_to_position(target : Vector2) -> float:
	var gun_pos = animated_sprite_2d.global_position
	if (target - gun_pos).y > 0:
		return 0
	
	var angle = gun_pos.angle_to_point(target)
	if facing < 0:
		return PI - angle
	return angle

func start_firing() -> void:
	firing = true
	animated_sprite_2d.play("fire")
	should_show_tracer_line = true
	gpu_particles_2d.emitting = true
	fire_audio_stream_player_2d.play()
	
func stop_firing() -> void:
	firing = false
	animated_sprite_2d.play("idle")
	tracer_line.visible = false
	gpu_particles_2d.emitting = false
	fire_audio_stream_player_2d.stop()
	
func handle_firing() -> void:
	if cooldown > 0:
		cooldown -= 1
		if cooldown <= 1:
			tracer_line.visible = false
		return
	cooldown = cooldown_period
	
	tracer_line.visible = should_show_tracer_line
	should_show_tracer_line = !should_show_tracer_line
	
	if !ray_cast_2d.is_colliding():
		tracer_line.points[1].x = 200
		return
	var point = ray_cast_2d.get_collision_point()
	var effect = HIT_EFFECT.instantiate()
	var target = ray_cast_2d.get_collider()
	
	if target is HurtBoxComponent:
		effect.global_position = point + Vector2(randi_range(-3, 3), randi_range(-3, 3))
		effect.play("hit_enemy")
		target.deal_damage(damage)
	else:
		effect.global_position = point 
		effect.play("hit_wall")
	effect.rotation = ray_cast_2d.global_position.angle_to_point(point)

	
	var length = (effect.global_position - ray_cast_2d.global_position).length()
	tracer_line.points[1].x = length
		
	Effects.add_effect(effect)
	
