extends Node


@onready var previous_window_mode := DisplayServer.window_get_mode()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		toggle_fullscreen()
	elif event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func toggle_fullscreen():
	var current := DisplayServer.window_get_mode()
	if current == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))
	else:
		previous_window_mode = current
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
