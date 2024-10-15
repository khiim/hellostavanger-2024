extends CharacterBody2D

const FALL_OFF_SCREEN = preload("res://scenes/effects/fall_off_screen.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var right_floor_detect: RayCast2D = $RightFloorDetect
@onready var left_floor_detect: RayCast2D = $LeftFloorDetect
@onready var right_wall_detect: RayCast2D = $RightWallDetect
@onready var left_wall_detect: RayCast2D = $LeftWallDetect
@onready var axe_hit_box_component: HitBoxComponent = $AxeHitBoxComponent

@export var direction : int = 1

const SPEED = 50.0

func _ready():
	set_flipped_state()

func set_flipped_state():
	animated_sprite_2d.flip_h = direction < 0
	axe_hit_box_component.scale = Vector2(direction, 1)

func flip():
	direction = -direction
	set_flipped_state()

func _physics_process(_delta: float) -> void:
	if (!is_on_floor()):
		velocity.y = 100
		move_and_slide()
		return

	if direction == 1 && (!right_floor_detect.is_colliding() || right_wall_detect.is_colliding()):
		flip()
	elif direction == -1 && (!left_floor_detect.is_colliding() || left_wall_detect.is_colliding()):
		flip()
	
	velocity.x = direction * SPEED
	
	move_and_slide()


func _on_hurt_box_component_hurt(_damage: int) -> void:
	die()

func die() -> void:
	var effect = FALL_OFF_SCREEN.instantiate()
	effect.init_from_animated_sprite(animated_sprite_2d)
	add_sibling(effect)
	queue_free()
