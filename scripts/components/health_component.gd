class_name HealthComponent
extends Node

signal max_health_changed(new_max_health : int, previous_max_health : int)
signal health_changed(new_health : int, previous_health : int)
signal died

@export var max_health : int = 1:
	get:
		return max_health
	set(value):
		var previous = max_health
		max_health = value
		if previous != max_health:
			max_health_changed.emit(max_health, previous)
		if health > max_health:
			health = max_health

@export var health : int = 1:
	get:
		return health
	set(value):
		var previous = health
		health = clampi(value, 0, max_health)
		if previous != health:
			health_changed.emit(health, previous)
		if health == 0:
			died.emit()
