class_name HitBoxComponent
extends Area2D

signal hit(hurtbox : HurtBoxComponent)

@export var damage : int = 1

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		if (damage > 0):
			area.deal_damage(damage)
		hit.emit(area)
