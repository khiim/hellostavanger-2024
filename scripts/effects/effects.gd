extends Node

var effect_layer : Node2D

func add_effect(effect : Node2D) -> void:
	effect_layer.add_child(effect)
