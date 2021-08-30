extends PlayerState

export (bool) var debug = false

export (float,0,5,0.5) var time_to_react = 1 #time taken to reach max speed
export (float,0,200) var MAX_SPEED = 40
export (float,0,200) var MAX_VERTICAL_VELOCITY = 30
export (float,0,100,1) var propultion_duration = 10.0 #for how long player can fly

#converting units
#from blocks to pixel
onready var max_speed = MAX_SPEED * G_Vars.block_size
onready var max_vertical_velocity = MAX_VERTICAL_VELOCITY * G_Vars.block_size

func fixed_update(delta : float) -> void:
	
	#decrease propultion if it's greater than 0
	if propultion_duration > 0:
		propultion_duration = timer(propultion_duration,delta)
	
	#applynig motion in x-axis
	if player.dir.x != 0:
		player.velocity.x = lerp(player.velocity.x, max_speed * player.dir.x, delta * time_to_react)
	#stopping player in x-axis 
	elif player.dir.x == 0:
		player.velocity.x = lerp(player.velocity.x, 0, delta * time_to_react)
	
	#applynig motion in y-axis
	if player.dir.y != 0:
		player.velocity.y = lerp(player.velocity.y, max_speed * player.dir.y, delta * time_to_react)
	#stopping player in y-axis
	elif player.dir.y ==0:
		player.velocity.y = lerp(player.velocity.y, max_speed * player.dir.y, delta * time_to_react)
	
	#falling slowly if player is not moving in any direction
	if player.dir.y == 0 and player.dir.x == 0:
		player.velocity.y += max_vertical_velocity * delta
	
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP) #appling motion
	

#function dedicated for switching states
#same as fixed_update but without delta
func state_update() -> void:
	
	#shutting down jet with specific key presses or propultion is zero
	if ((Input.is_action_pressed("Sprint") and Input.is_action_pressed("duck")) or propultion_duration <= 0) and not player.is_on_floor():
		state_machine.transition_to("Air", {fall_slowly = " ", _speed = max_speed}) #switch to air and fall slowly just to make it look cool
	
	#switching to idle if player hit ground
	if player.is_on_floor() and player.dir.x == 0:
		state_machine.transition_to("Idle")
	
	#switching to Run if player hit ground and wants to move
	#impossible in real life scenerios
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")


#function called when exiting this state
func exit(new_state := "") -> void:
	player.velocity = Vector2.ZERO


#timer function to substract 1 per second
func timer(time : float, delta : float) -> float:
	return time - delta

