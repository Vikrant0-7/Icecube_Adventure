extends StupidState

func start() -> void:
	Self.dir.x = 1

func fixed_update(delta: float) -> void:
	if not Self.is_stupid:
		if can_fall():
			switch_direction()
	Self.velocity.y += 500 * delta
	Self.velocity.x = Self.dir.x * 100
	Self.velocity = Self.move_and_slide(Self.velocity, Vector2.UP)

func can_fall() -> bool:
	$Move_with_you.global_position = Self.global_position
	$Move_with_you.scale.x = Self.dir.x
	$Move_with_you/RayCast2D.force_raycast_update()
	return not $Move_with_you/RayCast2D.is_colliding()

func switch_direction() -> void:
	Self.dir.x *= -1




