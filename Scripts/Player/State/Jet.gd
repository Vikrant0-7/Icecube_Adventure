extends PlayerState

export (bool) var debug = false

export (float,0,5,0.5) var time_to_react = 1
export (float,0,200,10) var max_speed = 40
export (float,0,200,10) var max_vertical_velocity = 30
export (float,0,100,1) var propultion_duration = 10.0

func fixed_update(delta : float) -> void:

	if propultion_duration > 0:
		propultion_duration = timer(propultion_duration,delta)
	if player.dir.x != 0:
		player.velocity.x = lerp(player.velocity.x, max_speed * player.dir.x, delta * time_to_react)
	elif player.dir.x == 0:
		player.velocity.x = lerp(player.velocity.x, 0, delta * time_to_react)
	
	if player.dir.y != 0:
		player.velocity.y = lerp(player.velocity.y, max_speed * player.dir.y, delta * time_to_react)
	elif player.dir.y ==0:
		player.velocity.y = lerp(player.velocity.y, max_speed * player.dir.y, delta * time_to_react)
	if player.dir.y == 0 and player.dir.x == 0:
		player.velocity.y += max_vertical_velocity * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	

func state_update() -> void:
	if ((Input.is_action_pressed("Sprint") and Input.is_action_pressed("duck")) or propultion_duration <= 0) and not player.is_on_floor():
		state_machine.transition_to("Air", {fall_slowly = " ", _speed = max_speed})
	if player.is_on_floor() and player.dir.x == 0:
		state_machine.transition_to("Idle")
	if player.is_on_floor() and player.dir.x != 0:
		state_machine.transition_to("Run")

func exit(new_state := "") -> void:
	player.velocity = Vector2.ZERO
	

func timer(time : float, delta : float) -> float:
	return time - delta

