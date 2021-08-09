#Air.gd

extends PlayerState


export var jump_height : float                    #how many blocks high should player jump
export var time_to_peak : float              #time it takes to reach jump_height
export var time_to_descent : float           #time it takes to fall back to ground from jump_height 
export var one_block_size : int =  64             #height of one block

onready var jump_velocity : float = ((2.0 * jump_height * one_block_size) / time_to_peak) * -1.0  #calulates jump velocity
onready var jump_gravity : float = ((-2.0 * jump_height * one_block_size) / (time_to_peak * time_to_peak)) * -1.0 #calculates gravity during jump

#equals to jump_gravity if time_to_peak = time_to_descent
onready var fall_gravity : float = ((-2.0 * jump_height * one_block_size) / (time_to_descent * time_to_descent)) * -1.0 #calculates normal gravity

export (float,0,10,1) var DRAG = 10

var can_jump : bool = true


onready var Run := get_parent().get_node("Run")
onready var Idle := get_parent().get_node("Idle")

#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	
	#jump if do_jump arguement is passed
	if msg.has("do_jump"):
		if msg.get("do_jump") and can_jump:
			player.velocity.y = jump_velocity
			can_jump = false


#virtual method called when physhics is update updated
func fixed_update(delta : float) -> void:
	
	player.velocity.y += get_gravity() * delta  #applying gravity
	
	if player.dir.x != 0:
		if Input.is_action_pressed("Sprint"):
			Run.spd = player.dir.x * Run.sprint_speed
			Run.accel = Run.sprint_acceleration
		else:
			Run.spd = player.dir.x * Run.speed
			Run.accel = Run.acceleration
		player.velocity.x = lerp(player.velocity.x, Run.spd, Run.accel)  #applying special air movement if direction key is pressed
	else:
		player.velocity.x = lerp(player.velocity.x, 0, delta * DRAG)  #applying drag in air to stop movement
	
	
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

#returns value of gravity directed by player y velocity
func get_gravity() -> float:
	return jump_gravity if player.velocity.y < 0.0 else fall_gravity
