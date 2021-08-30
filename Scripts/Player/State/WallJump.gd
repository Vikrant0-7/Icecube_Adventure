#WallJump.gd

extends PlayerState

export (float,1,100) var WALL_JUMP_FORCE  #force by which player moves away from wall
export (float,0,2,0.5) var no_control_state  #for how long player can't be controlled mid air
export (float,0,500) var WALL_GRAVITY  #gravity when sliding with wall


#converting units 
#from blocks to pixel
onready var wall_jump_force = WALL_JUMP_FORCE * G_Vars.block_size 
onready var wall_gravity = WALL_GRAVITY * G_Vars.block_size

var jump #jump force supplied by other states mainly air

func enter(msg := {}) -> void:
	
	#getting jump force if supplied by previous state
	if msg.has("jump_force"):
		jump = msg.get("jump_force")

func fixed_update(delta : float) -> void:
	#applying constant force towards wall so that is_on_wall() works properly
	player.velocity.x = player.dir.x * 100
	
	#applying slower wall gravity
	player.velocity.y += wall_gravity * delta
	
	#jump if user wants to
	if Input.is_action_just_pressed("Jump"):
		#applying max force in direction opposite to direction of input
		player.velocity.x = player.dir.x * -1 * wall_jump_force
		player.velocity.y = jump #applying upwards jump force
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func state_update() -> void:
	#switch to air if player did wall jump
	if not player.is_on_wall() and not player.is_on_floor():
		state_machine.transition_to("Air",{disable_control = no_control_state, dir = -player.dir.x}) #disabling controls so player can't move towards wall after jump
	#if player slide down the wall and reached floor switch to Idle
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	
	#if player slide down the wall and reached floor and wants to move switch to Run
	#not possible in real life scenarios
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")
