#WallJump.gd

extends PlayerState

export (float,1,100) var WALL_JUMP_FORCE

onready var wall_jump_force = WALL_JUMP_FORCE * G_Vars.block_size
 
export (float,0,2,0.5) var no_control_state
export (float,0,500) var WALL_GRAVITY
onready var wall_gravity = WALL_GRAVITY * G_Vars.block_size

var jump

func enter(msg := {}) -> void:
	if msg.has("jump_force"):
		jump = msg.get("jump_force")

func fixed_update(delta : float) -> void:
	player.velocity.x = player.dir.x * 100
	player.velocity.y += wall_gravity * delta
	if Input.is_action_just_pressed("Jump"):
		player.velocity.x = player.dir.x * -1 * wall_jump_force
		player.velocity.y = jump
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func state_update() -> void:
	if not player.is_on_wall() and not player.is_on_floor():
		state_machine.transition_to("Air",{disable_control = no_control_state})
	if player.is_on_floor():
		state_machine.transition_to("Idle")
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")
