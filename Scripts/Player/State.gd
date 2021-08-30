class_name State

extends Node

var state_machine : StateMachine = null

func start() -> void:
	pass

func handle_input(event : InputEvent) -> void:
	pass

func update(delta : float) -> void:
	pass

func fixed_update(delta : float) -> void:
	pass

func state_update() -> void:
	pass

func enter(msg  := {}) -> void:
	pass

func exit(new_state := "") -> void:
	pass
