extends StupidState

var target : Player
var chase_distance
var chase_speed : float


var dir : Vector2


func start() -> void:
	chase_distance = Self.chase_distance * G_Vars.block_size
	chase_speed = Self.chase_speed * G_Vars.block_size


func enter(msg := {}):
	if msg.has("target"):
		target = msg.get("target",null)

func fixed_update(delta : float) -> void:
	Self.velocity.y += G_Vars.block_size * Self.gravity * delta
	dir = target.global_position - Self.global_position
	dir = dir.normalized()
	Self.velocity.x = dir.x * chase_speed
	Self.velocity = Self.move_and_slide(Self.velocity, Vector2.UP)

func can_fall() -> bool:
	$Move_with_you.global_position = Self.global_position
	$Move_with_you.scale.x = sign(dir.x)
	$Move_with_you/RayCast2D.force_raycast_update()
	return not $Move_with_you/RayCast2D.is_colliding()

func state_update() -> void:
	if target == null or Self.global_position.distance_squared_to(target.global_position) > chase_distance * chase_distance:
		state_machine.transition_to("Patrol")
	if can_fall():
		state_machine.transition_to("Patrol",{freeze = 1})

func exit(state_name := "") -> void:
	target = null
