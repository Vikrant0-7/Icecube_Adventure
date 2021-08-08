#Air.gd

extends PlayerState


export (float,500,5000,10) var jump_velocity = 100
export (float,0,10000,10) var GRAVITY = 1000
export (float,0,1,.01) var DRAG = 1

var can_jump : bool = true


onready var Run := get_parent().get_node("Run")
onready var Idle := get_parent().get_node("Idle")

#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	
	#jump if do_jump arguement is passed
	if msg.has("do_jump"):
		if msg.get("do_jump") and can_jump:
			player.velocity.y = -jump_velocity
			can_jump = false


#virtual method called when physhics is update updated
func fixed_update(delta : float) -> void:
	
	player.velocity.y += GRAVITY * delta  #applying gravity
	
	if player.dir.x != 0:
		player.velocity.x = lerp(player.velocity.x, player.dir.x * Run.speed, DRAG)  #applying special air movement if direction key is pressed
	else:
		player.velocity.x = lerp(player.velocity.x, 0, DRAG)  #applying drag in air to stop movement
	
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	#canceling jump if player let jump key go
	if player.dir.y <= -2 and player.velocity.y < 0:
		player.velocity.y = 0

#special virtual method for logic to switch states
func state_update() -> void:
	
	#switch to idle if player is on floor and is not moving
	if player.is_on_floor() and is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
	
	#switch to Run if player is on floor and want to move 
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")
	
	#switch to Run so Player's 'x' speed can be reduced to zero
	if player.is_on_floor() and not is_zero_approx(player.velocity.x):
		state_machine.transition_to("Run")

#virtual method called when state is being switch from this state to other
func exit() -> void:
	player.velocity.y = 100  #setting some speed in y direction so is_on_floor works properly

