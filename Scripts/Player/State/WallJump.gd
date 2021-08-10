#WallJump.gd

extends PlayerState

export (float,100,1000,50) var wall_jump_force 
export (float,0,2,0.5) var no_control_state
export (float,100,500,10) var wall_gravity

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
