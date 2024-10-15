extends Node2D

@export var player : PackedScene

@onready var player_layer: Node2D = %PlayerLayer
@onready var player_spawn: Marker2D = %PlayerSpawn
@onready var victory_layer: Node2D = $VictoryLayer

func _ready() -> void:
	Effects.effect_layer = %EffectsLayer
	spawn_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		call_deferred("spawn_player")
	

func spawn_player() -> void:
	var instance = player.instantiate()
	instance.global_position = player_spawn.global_position
	for child in player_layer.get_children():
		child.queue_free()
	player_layer.add_child(instance)


func _on_dragon_died() -> void:
	victory_layer.visible = true
