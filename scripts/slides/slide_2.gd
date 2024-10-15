extends Node2D

@onready var agenda_label: RichTextLabel = %AgendaLabel

var counter := 0

var agenda = ["About me", "Intro to Godot", "Fight Dragon", "Final Thoughts"]

func _ready() -> void:
	reset_agenda()

func add_agenda() -> void:
	counter += 1
	if counter > agenda.size():
		reset_agenda()
		return
	
	agenda_label.append_text("[ul] " + agenda[counter-1] + "[/ul]")


func reset_agenda() -> void:
	counter = 0
	agenda_label.clear()
	agenda_label.append_text(" Agenda")

func _on_box_hit() -> void:
	add_agenda()
