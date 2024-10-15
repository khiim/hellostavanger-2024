extends Node2D

@onready var about_me_label: RichTextLabel = %AboutMeLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var counter := 0

var bullet_points = ["Married, 3 children", "Storebrand", "D&D and gamdev"]

func _ready() -> void:
	reset_slide()

func add_point() -> void:
	counter += 1
	if counter > bullet_points.size():
		reset_slide()
		return
	
	about_me_label.append_text("\n         " + bullet_points[counter-1])


func reset_slide() -> void:
	counter = 0
	about_me_label.clear()
	about_me_label.append_text(" About me")
	animation_player.play("RESET")


func _on_area_2d_1_body_entered(_body: Node2D) -> void:
	animation_player.play("1")

func _on_area_2d_2_body_entered(_body: Node2D) -> void:
	animation_player.play("2")

func _on_area_2d_3_body_entered(_body: Node2D) -> void:
	animation_player.play("3")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "RESET":
		add_point()
	
