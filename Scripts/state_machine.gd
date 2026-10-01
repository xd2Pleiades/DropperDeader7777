extends Node

@onready var initial_state = $"Human Idle"

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	print("Transition requested: ", new_state_name)
	if state != current_state:
		print("Rejected - not current state")
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("State not found: ", new_state_name)
		print("Available states: ", states.keys())
		return
	if current_state:
		current_state.Exit()
	new_state.Enter()
	current_state = new_state
