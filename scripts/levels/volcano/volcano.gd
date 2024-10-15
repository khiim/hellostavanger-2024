extends Node2D

const LAIR = preload("res://scenes/levels/lair/lair.tscn")

@onready var player_layer: Node2D = %PlayerLayer
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var coffee_bar: TextureRect = %CoffeeBar

@onready var player_spawn: Marker2D = %PlayerSpawn
@onready var respawn_timer: Timer = $RespawnTimer

@export var player : PackedScene

@export var shake_value : float = 1

func _ready() -> void:
	Effects.effect_layer = %EffectsLayer
	calc_camera_limits()
	spawn_player()


func calc_camera_limits() -> void:
	var map_limits = tile_map_layer.get_used_rect()
	var map_cellsize = tile_map_layer.tile_set.tile_size
	camera_2d.limit_left = 0
	camera_2d.limit_right = map_limits.end.x * map_cellsize.x
	camera_2d.limit_top = 0
	camera_2d.limit_bottom = 360

func spawn_player() -> void:
	if !player: return
	var instance = player.instantiate()
	instance.global_position = player_spawn.global_position
	if instance.has_method("set_camera"):
		instance.set_camera(camera_2d)
	if instance.has_signal("died"):
		instance.died.connect(_on_player_died)
	if instance.has_signal("coffee_changed"):
		instance.coffee_changed.connect(_on_coffee_changed)
		coffee_bar.visible = true
	player_layer.add_child(instance)

func _on_player_died() -> void:
	respawn_timer.start()

func _on_respawn_timer_timeout() -> void:
	spawn_player()

func _on_coffee_changed(coffee : int) -> void:
	coffee_bar.coffee = coffee

func _on_lair_portal_area_2d_body_entered(_body: Node2D) -> void:
	if !player:
		return
	var lair = LAIR.instantiate()
	lair.player = player
	call_deferred("add_sibling", lair)
	queue_free()
