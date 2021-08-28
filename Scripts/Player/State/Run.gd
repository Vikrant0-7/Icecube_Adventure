#Run.gd

extends PlayerState

export (float,0,100) var SPEED

onready var speed = SPEED * G_Vars.block_size

export (float,0,1,0.1) var acceleration = 0.1
export (float,0,1,0.1) var friction = 0.1
export (float,0,1000,10) var sprint_speed = 100
export (float,0,1,0.1) var sprint_acceleration = 0.1
export (float,0,10,0.5) var sprint_stamina = 2
export (float,0,10,0.5) var sprint_tiredness = 2

onready var Idle := get_parent().get_node("Idle")
onready var Air := get_parent().get_node("Air")

var accel : float
var spd : float
var can_sprint : bool = false
var stamina : float
#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	pass


#virtual method called when physhics is update updated
func fixed_update(delta : float) -> void:

	
	player.velocity.y = 100 #adding downwards velocity so is_on_floor() works properly
	
	 #increasing max speed and accel if user wats to sprint
	if Input.is_action_pressed("Sprint") and can_sprint and not is_zero_approx(player.velocity.x):
		stamina = timer(stamina,delta) #adding second using timer function
		spd = sprint_speed
		accel = sprint_acceleration
		#if time sprinted exceeds sprint stamina then player is no longer to sprint
		if stamina >= sprint_stamina and can_sprint:
			stamina = sprint_stamina * sprint_tiredness #managing how long player is unable to sprint
			can_sprint = false
	else:
		#substracting seconds elapsed untill it becomes zero
		if stamina > 0:
			stamina = timer(stamina,delta,-1)
		#giving back player ability to sprint again
		if  stamina <= 0 and not can_sprint:
			stamina = 0
			can_sprint = true
		spd = speed
		accel = acceleration
	
	#making player move as per user input
	if player.dir.x != 0:
		player.velocity.x = lerp(player.velocity.x, player.dir.x * spd ,accel)
	
	#making player stop if no user input
	else:
		player.velocity.x = lerp(player.velocity.x, 0, friction)
	var snap = Vector2.DOWN * 16 if player.is_on_floor() else Vector2.ZERO
	player.velocity = player.move_and_slide_with_snap(player.velocity,snap, Vector2.UP) #applying velocity to player

#special virtual method for logic to switch states
func state_update() -> void:
	
	#switch state to idle if player is not moving and no input is given by user
	if is_in_range(player.velocity.x,10) and player.dir.x == 0:
		state_machine.transition_to("Idle")
	
	#switching state to air such that player can jump if user press jump button
	if Input.is_action_just_pressed("Jump"):
		state_machine.transition_to("Air",{do_jump = true,_speed = spd , _accel = accel })
	
	#switching to air if player is not on ground such that player falls
	if not player.is_on_floor():
		state_machine.transition_to("Air",{do_jump = false, _speed = spd , _accel = accel})

#a simple timer function which adds or substract 1 float per second
func timer(time : float, delta : float, modifier : float = 1) -> float:
	return time + (1 * delta * modifier)

