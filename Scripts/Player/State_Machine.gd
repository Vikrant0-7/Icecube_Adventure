extends Node

class_name StateMachine

signal transition(state)

export var initial_state : NodePath

onready var state = get_node(initial_state)



func _ready() -> void:
	
	#waits untill player's ready function is called
	yield(owner,"ready")
	
	
	#assigns self as state machine to all childers
	for child in get_children():
		if child.has_method("enter"):
			child.state_machine = self
			child.start()
	state.enter()
	



func _unhandled_input(event : InputEvent) -> void:
	if owner.is_processing_unhandled_input():
		state.handle_input(event)

func _process(delta : float) -> void:
	if owner.is_processing():
		state.update(delta)

func _physics_process(delta : float) -> void:
	if owner.is_physics_processing():
		state.fixed_update(delta)
		state.state_update()
		get_parent().get_node("State_Display").text = state.name #to display state for debugging perpose

#to switch states
func transition_to(state_name : String, msg : Dictionary = {}) -> void:
	
	#return if state don'y exists
	if not has_node(state_name): #to avoid any possible errors
		return
	
	
	state.exit(state_name)
	state = get_node(state_name)
	state.enter(msg)
	emit_signal("transition",state.name)
