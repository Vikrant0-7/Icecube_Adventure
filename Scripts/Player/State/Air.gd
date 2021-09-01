#Air.gd

extends PlayerState


var max_jumps : int

var jump_velocity : float  #calulates jump velocity
var jump_gravity : float #calculates gravity during jump

#equals to jump_gravity if time_to_peak = time_to_descent
var fall_gravity : float  #calculates normal gravity
var drag : float

#powerups
var can_jet : bool = false 
var can_double_jump : bool = false
var can_wall_jump : bool = false



var can_jump : bool = true
var jumps : int = 0
var jump_power_reduction := 0.5

onready var Jet := get_parent().get_node("Jet")


#internal vars
var air_speed : float  #speed in air supplied by other states
var air_accel : float  #acceleration in air supplied by other states
var control_enabled : bool = true #for how long control is disabled i.e. player can move in one dir only
var dir : float #dir in which player can move in controls disabled state
var fall_slowly : bool = false #make player fall slowly to make it look cool. Supplied by other states


func start() -> void:
	jump_velocity = ((2.0 * player.jump_height * G_Vars.block_size) / player.time_to_peak) * -1.0
	jump_gravity = ((-2.0 * player.jump_height * G_Vars.block_size) / (player.time_to_peak * player.time_to_peak)) * -1.0
	fall_gravity = ((-2.0 * player.jump_height * G_Vars.block_size) / (player.time_to_descent * player.time_to_descent)) * -1.0
	drag = player.drag
	max_jumps = player.max_jumps
	can_jet = player.can_jet
	can_double_jump = player.can_double_jump
	can_wall_jump = player.can_wall_jump


#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	if msg.has("disable_control"):
		control_enabled = false
		$Timer.start(msg.get("disable_control"))
		dir = msg.get("dir")
	
	if msg.has("fall_slowly"):
		fall_slowly = true
	else:
		fall_slowly = false
	
	#jump if do_jump arguement is passed
	if msg.has("do_jump"):
		if msg.get("do_jump") and can_jump:
			player.velocity.y = jump_velocity
			can_jump = false
	jumps += 1
	
	if msg.has("_speed"):
		air_speed = msg.get("_speed")
	if msg.has("_accel"):
		air_accel = msg.get("_accel")


#virtual method called when physhics is update updated
func fixed_update(delta : float) -> void:
	
	#double jump
	if Input.is_action_just_pressed("Jump") and jumps < max_jumps and not player.is_on_floor() and can_double_jump:
		jumps += 1
		player.velocity.y = jump_velocity / (jumps * jump_power_reduction)
	
	player.velocity.y += get_gravity() * delta  #applying gravity
	
	#moving player normally
	if player.dir.x != 0 and control_enabled:
		player.velocity.x = lerp(player.velocity.x, air_speed * player.dir.x , air_accel)  #applying special air movement if direction key is pressed
	
	#moving player in dir opposite to wall if did wall jump
	if player.dir.x == dir and not control_enabled:
		player.velocity.x = lerp(player.velocity.x, air_speed * player.dir.x , air_accel)
	
	#stopping player if no input is given by user
	else:
		player.velocity.x = lerp(player.velocity.x, 0,drag)  #applying drag in air to stop movement
	
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP) #applying motion


#special virtual method for logic to switch states
func state_update() -> void:
	
	#switch to idle if player is on floor and is not moving
	if player.is_on_floor() and is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
	
	#if player is on wall switch to wall_jump
	if player.is_on_wall() and player.velocity.y > 0 and can_wall_jump:
		state_machine.transition_to("WallJump", {jump_force = jump_velocity})
	
	#switch to Run if player is on floor and want to move 
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")
	
	#switch to Run so Player's 'x' speed can be reduced to zero
	if player.is_on_floor() and not is_zero_approx(player.velocity.x):
		state_machine.transition_to("Run")
	
	#if player wants to use jet
	if Input.is_action_pressed("Sprint") and Input.is_action_pressed("enable_special") and G_Vars.is_in_range(player.velocity.y, 10) and Jet.propultion_duration > 0:
		state_machine.transition_to("Jet", {g = fall_gravity})

#virtual method called when state is being switch from this state to other
func exit(new_state := "") -> void:
	if not $Timer.is_stopped():
		$Timer.stop()
	if not new_state == "WallJump":
		jumps = 0
		can_jump = true
	control_enabled = true
	player.velocity.y = 100  #setting some speed in y direction so is_on_floor works properly

#returns value of gravity directed by player y velocity
func get_gravity() -> float:
	if player.velocity.y < 0.0 or fall_slowly:
		return jump_gravity
	else:
		return fall_gravity


func on_timeout():
	control_enabled = true
