extends PlayerState


var time_to_react : float       #time taken to reach max speed
var propultion_duration : float   #for how long player can fly
var speed: Vector2

func start() -> void:
	time_to_react = player.time_to_react
	propultion_duration = player.propultion_duration
	speed = player.speed * G_Vars.block_size

func fixed_update(delta : float) -> void:
	
	#decrease propultion if it's greater than 0
	if propultion_duration > 0:
		propultion_duration = timer(propultion_duration,delta)
	
	#applynig motion in x-axis
	if player.dir.x != 0:
		player.velocity.x = lerp(player.velocity.x, speed.x * player.dir.x, delta * time_to_react)
	#stopping player in x-axis 
	elif player.dir.x == 0:
		player.velocity.x = lerp(player.velocity.x, 0, delta * time_to_react)
	
	#applynig motion in y-axis
	if player.dir.y != 0:
		player.velocity.y = lerp(player.velocity.y, speed.y * player.dir.y, delta * time_to_react)
	#stopping player in y-axis
	elif player.dir.y ==0:
		player.velocity.y = lerp(player.velocity.y, speed.y * player.dir.y, delta * time_to_react)
	
	#falling slowly if player is not moving in any direction
	if player.dir.y == 0 and player.dir.x == 0:
		player.velocity.y += speed.y * delta
	
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP) #appling motion
	

#function dedicated for switching states
#same as fixed_update but without delta
func state_update() -> void:
	
	#shutting down jet with specific key presses or propultion is zero
	if ((Input.is_action_pressed("Sprint") and Input.is_action_pressed("duck")) or propultion_duration <= 0) and not player.is_on_floor():
		state_machine.transition_to("Air", {fall_slowly = " ", _speed = speed.x}) #switch to air and fall slowly just to make it look cool
	
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

