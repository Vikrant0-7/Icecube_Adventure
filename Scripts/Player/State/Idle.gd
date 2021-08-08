#Idle.gd

extends PlayerState

onready var Run := get_parent().get_node("Run")
onready var Air := get_parent().get_node("Air")

#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	#If user let go jump key then mamke player able to jump again
	if player.dir.y == 0:
		Air.can_jump = true



#virtual method called when physhics is update updated
func fixed_update(delta) -> void:
	#If user let go jump key then mamke player able to jump again
	if player.dir.y == 0:
		Air.can_jump = true


#special virtual method for logic to switch states
func state_update() -> void:
	#Switch to Run state if player is on floor and pressing directional keys
	if player.dir.x != 0 and player.is_on_floor():
		state_machine.transition_to("Run")
	
	#Switch to Air state such that player can jump
	if player.dir.y == -1 and player.is_on_floor() and Air.can_jump:
		state_machine.transition_to("Air",{do_jump = true})
	
	#Switch to Air state such that player isn't jumping
	elif not player.is_on_floor():
		state_machine.transition_to("Air",{do_jump = false})
	
