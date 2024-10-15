class_name Burning
extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func burn():
	animated_sprite_2d.play("burning")
