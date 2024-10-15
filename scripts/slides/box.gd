class_name Box
extends StaticBody2D

signal hit

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _has_been_hit : bool = false

func jump_into_box() -> void:
	if _has_been_hit:
		return
	
	_has_been_hit = true
	hit.emit()
	animation_player.play("hit")
	audio_stream_player_2d.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "hit":
		return
	_has_been_hit = false

func change_to_godot_box() -> void:
	animated_sprite_2d.play("godotbox")
	animated_sprite_2d.scale = Vector2(0.125, 0.125)
