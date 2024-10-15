extends Path2D

const FALL_OFF_SCREEN = preload("res://scenes/effects/fall_off_screen.tscn")
const MYGG_LASER = preload("res://scenes/enemies/mygg_laser.tscn")

@export var speed : float = 50

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var health_component: HealthComponent = %HealthComponent
@onready var detection_area_2d: Area2D = %DetectionArea2D

var reverse : bool = false
var want_to_fire : bool = false

func _physics_process(delta):
	var movement = speed * delta
	
	if reverse:
		path_follow_2d.progress -= movement
		if is_zero_approx(path_follow_2d.progress):
			reverse = false
	else:
		path_follow_2d.progress += movement
		if (path_follow_2d.progress_ratio >= 1):
			reverse = true

	if detection_area_2d.has_overlapping_bodies() && want_to_fire:
		var player = detection_area_2d.get_overlapping_bodies()[0]
		var laser = MYGG_LASER.instantiate()
		laser.target_player(animated_sprite_2d.global_position, player.global_position)
		want_to_fire = false
		Effects.add_effect(laser)
		

func _on_hurt_box_component_hurt(damage: int) -> void:
	health_component.health -= damage


func _on_health_component_died() -> void:
	var effect = FALL_OFF_SCREEN.instantiate()
	effect.init_from_animated_sprite(animated_sprite_2d)
	add_sibling(effect)
	queue_free()


func _on_timer_timeout() -> void:
	want_to_fire = true
