#Run.gd

extends PlayerState

export (float,0,1000,10) var speed = 100
export (float,0,1,0.1) var acceleration = 0.1
export (float,0,1,0.1) var friction = 0.1


onready var Idle := get_parent().get_node("Idle")
onready var Air := get_parent().get_node("Air")

#method is called when player's state is switched to this state
func enter(msg := {}) -> void:
	pass


#virtual method called when physhics is update updated
func fixed_update(delta : float) -> void:
	player.velocity.y = 100
	if player.dir.x != 0:
		player.velocity.x = lerp(player.velocity.x, player.dir.x * speed, acceleration)
	else:
		player.velocity.x = lerp(player.velocity.x, player.dir.x * speed, friction)
	
	player.velocity = player.move_and_slide(player.velocity,Vector2.UP)
	
	if player.dir.y == 0:
		Air.can_jump = true

#special virtual method for logic to switch states
func state_update() -> void:
	if is_zero_approx(player.velocity.x) and player.dir.x == 0:
		state_machine.transition_to("Idle")
	if player.dir.y == -1 and Air.can_jump:
		state_machine.transition_to("Air",{do_jump = true})
	if not player.is_on_floor():
		state_machine.transition_to("Air",{do_jump = false})

