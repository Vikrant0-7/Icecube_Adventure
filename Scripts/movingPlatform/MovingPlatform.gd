tool

extends KinematicBody2D

class_name MovingPlatform

var speed : float
var closed_loop : bool = false

onready var path : Line2D = get_parent()

var points : PoolVector2Array
var points_to_move : Array
var velocity : Vector2
var next_move_pos : Vector2

var cycles : int = 0

func _ready() -> void:
	yield(owner,"ready")
	points = path.points
	for i in range(points.size()):
		points[i] += path.global_position
		print(is_even(i))
	global_position = points[0]
	points_to_move = points

func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	if points_to_move.size() > 0:
		var next_pos = points_to_move[0]
		if next_move_pos == Vector2.ZERO:
			next_move_pos = next_pos
		var distance = global_position.distance_to(next_move_pos)
		dir = next_pos - global_position
		dir = dir.normalized()
		
		velocity = dir * speed * delta
		
		global_position += velocity
		
		if(abs(global_position.x - next_move_pos.x) <= 0.7 and abs(global_position.y - next_move_pos.y) <= 0.7):
			points_to_move.remove(0)
			next_move_pos = Vector2.ZERO
	
	if points_to_move.size() == 0:
		if closed_loop:
			points_to_move = points
		else:
			cycles += 1
			if is_even(cycles):
				points_to_move = points
				cycles = 0
			else:
				points_to_move = invert(points)


func is_even(i : int) -> bool:
	return (i % 2) == 0

func invert(a : Array) -> Array:
	var b : Array
	for i in range(a.size()):
		b.append(a.pop_back())
	return b

func set_vars(a : float,b : bool) -> void:
	speed = a
	closed_loop = b
