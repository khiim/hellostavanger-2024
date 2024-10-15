class_name StateMachine
extends Node

@export var player : Player
@export var initial_state : State

var states : Dictionary = {}

var current_state : State
var go_to_state : State

var is_initialized : bool = false

func _ready() -> void:
	if player == null: push_error("Missing player in StateMachine")
	if initial_state == null: push_error("Missing initial_state in StateMachine")
	
	var state_list = find_children("*", "State")
	for state in state_list:
		states[state.name] = state
		state.player = player
		state.states = states
		state.state_machine = self
	
	if initial_state:
		call_deferred("_set_state", initial_state)

func initialize() -> void:
	if is_initialized: return
	for state in states:
		states[state].initialize()

func update(delta : float) -> void:
	if current_state == null:
		return
	var new_state = current_state.update(delta)
	_set_state(new_state)

func change_state(new_state : State) -> void:
	call_deferred("_set_state", new_state)
	
func is_in_state(state : State) -> bool:
	if current_state == null: return false
	return current_state == state

func is_in_state_named(state_name : String) -> bool:
	if current_state == null: return false
	return current_state.name == state_name

func _set_state(new_state : State) -> void:
	if new_state == null:
		return
	
	if new_state == current_state:
		print("Attempt at setting to current state ", current_state)
		return
	
	if current_state != null:
		current_state.exit_state()
	current_state = new_state
	current_state.enter_state()
