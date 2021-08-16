extends PlayerState



func fixed_update(delta : float) -> void:
	player.velocity.y = 100
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func state_update() -> void:
	if not Input.is_action_pressed("Jump") or not Input.is_action_pressed("Sprint") and not player.is_on_floor():
		state_machine.transition_to("Air")
	if player.is_on_floor() and player.dir.x == 0:
		state_machine.transition_to("Idle")
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")
