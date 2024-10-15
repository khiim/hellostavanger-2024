class_name HurtBoxComponent
extends Area2D

@onready var invulnerable_timer: Timer = $InvulnerableTimer

@export var auto_invulnerable : bool = false
@export_range(0, 30, 0.1, "suffix:s") var invulnerable_time : float = 1:
	set(value):
		invulnerable_time = value

@export var invulnerable : bool = false:
	set(value):
		invulnerable = value
		set_deferred("monitorable", !invulnerable)
		set_deferred("monitoring", !invulnerable)
		if invulnerable: invulnerable_timer.start()

signal hurt(damage : int)

func deal_damage(damage : int) -> void:
	invulnerable_timer.wait_time = invulnerable_time
	if invulnerable: return
	hurt.emit(damage)
	if auto_invulnerable: invulnerable = true


func _on_invulnerable_timer_timeout() -> void:
	invulnerable = false
