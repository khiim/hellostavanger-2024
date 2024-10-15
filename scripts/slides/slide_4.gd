extends Node2D

@onready var godot_label: RichTextLabel = %GodotLabel
@onready var box: Box = $Box

var counter := 0
var bullet_points = ["2D & 3D", "Nodes & Scenes", "Scripts (GDScript & C#)", "Export"]

func _ready() -> void:
	box.change_to_godot_box()
	reset_slide()

func add_point() -> void:
	counter += 1
	if counter > bullet_points.size():
		reset_slide()
		return
	
	godot_label.append_text("[ul] " + bullet_points[counter-1] + "[/ul]")

func reset_slide() -> void:
	counter = 0
	godot_label.clear()
	godot_label.append_text(" Godot")

func _on_box_hit() -> void:
	add_point()
