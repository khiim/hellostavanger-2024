extends Node2D

@onready var player_in_slides: CharacterBody2D = $PlayerInSlides
@onready var camera_2d: Camera2D = $Camera2D

var num_slides = 4
var current_slide = 0

func _ready() -> void:
	_on_player_in_slides_slide_changed(0)


func _on_player_in_slides_slide_changed(slide_number: int) -> void:
	camera_2d.global_position.x = slide_number * 320 + 160
	current_slide = slide_number
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		move_player_to_slide(0)
	elif event.is_action_pressed("2"):
		move_player_to_slide(1)
	elif event.is_action_pressed("ui_right") && current_slide < num_slides - 1:
		move_player_to_slide(current_slide + 1)
	elif event.is_action_pressed("ui_left") && current_slide > 0:
		move_player_to_slide(current_slide - 1)

func move_player_to_slide(slide : int) -> void:
	player_in_slides.global_position = Vector2(320 * slide + 40, 160)
	
