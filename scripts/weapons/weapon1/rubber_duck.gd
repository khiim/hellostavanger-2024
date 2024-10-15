extends RigidBody2D

const EXPLOSION = preload("res://scenes/effects/explosion.tscn")

var has_exploded := false

@onready var explosion_area_2d: Area2D = $ExplosionArea2D
@onready var quack_audio_stream_player_2d: AudioStreamPlayer2D = $QuackAudioStreamPlayer2D

func _ready() -> void:
	quack_audio_stream_player_2d.play()

func explode() -> void:
	if has_exploded:
		return
	has_exploded = true
	
	var overlapping_enemies := explosion_area_2d.get_overlapping_areas()
	
	for area in overlapping_enemies:
		if area is HurtBoxComponent:
			area.deal_damage(5)

	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)

	queue_free()

func _on_timer_timeout() -> void:
	explode()

func _on_hit_box_component_hit(_hurtbox: HurtBoxComponent) -> void:
	explode()
