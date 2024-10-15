extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var fall_gravity = 500
var velocity : Vector2 = Vector2(0, -100)
var rotation_speed = 1
var init_rotation : float
var init_offset : Vector2
var init_scale : Vector2
var init_flip_h : bool
var init_flip_v : bool
var init_texture : Texture2D

var init_hframes : int = -1
var init_vframes : int = -1
var init_frame : int = -1

func init_from_animated_sprite(in_sprite : AnimatedSprite2D) -> void:
	init(in_sprite.global_position, in_sprite.sprite_frames.get_frame_texture(in_sprite.animation, in_sprite.frame), in_sprite.offset, in_sprite.scale, in_sprite.rotation, in_sprite.flip_h, in_sprite.flip_v)

func init_from_sprite(in_sprite : Sprite2D) -> void:
	init(in_sprite.global_position, in_sprite.texture, in_sprite.offset, in_sprite.scale, in_sprite.rotation, in_sprite.flip_h, in_sprite.flip_v)
	init_hframes = in_sprite.hframes
	init_vframes = in_sprite.vframes
	init_frame = in_sprite.frame


func init(pos : Vector2, texture : Texture2D, offset : Vector2, scale_ : Vector2, rot : float, flip_h : bool, flip_v : bool) -> void:
	global_position = pos
	init_texture = texture
	init_offset = offset
	init_scale = scale_
	init_rotation = rot
	init_flip_h = flip_h
	init_flip_v = flip_v

func _ready() -> void:
	sprite.texture = init_texture
	sprite.offset = init_offset
	sprite.scale = init_scale
	sprite.rotation = init_rotation
	sprite.flip_h = init_flip_h
	sprite.flip_v = init_flip_v
	
	if init_frame >= 0:
		sprite.hframes = init_hframes
		sprite.vframes = init_vframes
		sprite.frame = init_frame
	
	velocity.x = randf_range(-100, 100)
	
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate:v", 1, 0.2).from(15)
	audio_stream_player_2d.play()

func _physics_process(delta: float) -> void:
	velocity.y += fall_gravity * delta
	sprite.position += velocity * delta
	sprite.rotate(rotation_speed * delta)



func _on_timer_timeout() -> void:
	print("Effect done")
	queue_free()
