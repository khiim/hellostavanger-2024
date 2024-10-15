extends Node2D

const BURNING = preload("res://scenes/levels/lair/burning.tscn")

signal died

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var burn_timer: Timer = $BurnTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var dragon_shadow: Sprite2D = $DragonShadow
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var hurt_box_component_2: HurtBoxComponent = $HurtBoxComponent2
@onready var burn_audio_stream_player_2d: AudioStreamPlayer2D = $BurnAudioStreamPlayer2D

var burning_instance : Burning
var dead : bool

func burn_player(body : Node2D):
	burning_instance = BURNING.instantiate()
	burning_instance.global_position = body.global_position
	body.add_sibling(burning_instance)
	body.queue_free()
	animation_player.play("start")
	burn_audio_stream_player_2d.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start":
		animation_player.play("burning")
		burn_timer.start()
	if anim_name == "end":
		animation_player.play("idle")
		burn_audio_stream_player_2d.stop()
	if anim_name == "death":
		died.emit()
		queue_free()

func _on_burn_area_2d_body_entered(body: Node2D) -> void:
	if dead: return
	burn_player(body)

func _on_burn_timer_timeout() -> void:
	animation_player.play("end")
	if !is_instance_valid(burning_instance): return
	burning_instance.burn()

func _on_hurt_box_component_hurt(damage: int) -> void:
	health_component.health -= damage


func _on_health_component_died() -> void:
	dead = true
	dragon_shadow.visible = false
	animation_player.play("death")
	hurt_box_component.queue_free()
	hurt_box_component_2.queue_free()
	
