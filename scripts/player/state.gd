class_name State
extends Node

var player : Player
var states : Dictionary = {}
var state_machine : StateMachine

func initialize() -> void:
	pass

func enter_state() -> void:
	pass
	
func exit_state() -> void:
	pass

func update(_delta : float) -> State:
	return null
