#Idle.gd

extends PlayerState

onready var Run := get_parent().get_node("Run")
onready var Air := get_parent().get_node("Air")

#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	player.velocity = Vector2.ZERO
	
	#If user let go jump key then mamke player able to jump again
	if player.dir.y == 0:
		Air.can_jump = true



#virtual method called when physhics is update updated
func fixed_update(delta) -> void:
	
	#regaining player stamina
	if Run.stamina > 0:
		Run.stamina = Run.timer(Run.stamina, delta, -1)
	
	#if stamin is zero giving player abitiy to run again
	if Run.stamina <= 0:
		Run.can_sprint = true
		Run.stamina = 0
	
	#snap vector so that player can ride moving platforms
	var snap = Vector2.DOWN * 16 if player.is_on_floor() else Vector2.ZERO
	
	#applying constant force towards ground so player can ride moving_platform 
	player.velocity.y += 100
	player.velocity = player.move_and_slide_with_snap(player.velocity,snap, Vector2.UP)


#special virtual method for logic to switch states
func state_update() -> void:
	#Switch to Run state if player is on floor and pressing directional keys
	if player.dir.x != 0 and player.is_on_floor():
		state_machine.transition_to("Run")
	
	#Switch to Air state such that player can jump
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		state_machine.transition_to("Air",{do_jump = true})
	
	#Switch to Air state such that player isn't jumping
	elif not player.is_on_floor():
		state_machine.transition_to("Air",{do_jump = false})
	
