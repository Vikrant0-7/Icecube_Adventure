extends StupidState

var can_switch := true

func start() -> void:
	if get_tree().get_nodes_in_group("Player").size() > 0:
		Self.dir.x = sign(get_tree().get_nodes_in_group("Player")[0].global_position.x - Self.global_position.x)
	if Self.detect_player:
		$Move_with_you/Area2D/CollisionShape2D.shape.radius = Self.radius * G_Vars.block_size

func enter(msg := {}):
	if msg.has("freeze"):
		can_switch = false
		$Timer.start(msg.get("freeze"))

func fixed_update(delta: float) -> void:
	if not Self.is_stupid:
		if can_fall() and Self.is_on_floor():
			switch_direction()
	if Self.is_on_wall():
		switch_direction()
	Self.velocity.y += Self.gravity * delta *G_Vars.block_size
	Self.velocity.x = Self.dir.x * Self.patrol_speed * G_Vars.block_size
	Self.velocity = Self.move_and_slide(Self.velocity, Vector2.UP)

func can_fall() -> bool:
	$Move_with_you.global_position = Self.global_position
	$Move_with_you.scale.x = Self.dir.x
	$Move_with_you/RayCast2D.force_raycast_update()
	return not $Move_with_you/RayCast2D.is_colliding()

func switch_direction() -> void:
	Self.dir.x *= -1

func _on_Area2D_body_entered(body: Player) -> void:
	if body is Player:
		var space_state := Self.get_world_2d().direct_space_state
		if space_state.intersect_ray(Self.global_position,body.global_position,[Self,self],0b10).size() == 0:
			Self.target = body
			if can_switch:
				state_machine.transition_to("Chase",{target = Self.target})


func _on_Area2D_body_exited(body: Node) -> void:
	if body is Player:
		Self.target = null


func _on_Timer_timeout() -> void:
	can_switch = true
