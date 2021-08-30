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
	
	yield(owner,"ready") #waiting parent to be ready as parent supplies variables
	points = path.points #getting points to move
	
	#making them global coordinates
	for i in range(points.size()):
		points[i] += path.global_position
		print(is_even(i))
	
	#setting global_position to first point
	global_position = points[0]
	points_to_move = points

func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	
	#following points if points_to_move is non-empty
	if points_to_move.size() > 0:
		
		#getting poition to move
		var next_pos = points_to_move[0]
		if next_move_pos == Vector2.ZERO:
			next_move_pos = next_pos
		
		#getting distace b/w global_position and position to move
		var distance = global_position.distance_to(next_move_pos)
		
		#getting direction to move in
		dir = next_pos - global_position
		dir = dir.normalized()
		
		#applying speed 
		velocity = dir * speed * delta
		
		#making platform move
		global_position += velocity
		
		#removing point if if reached it
		if(abs(global_position.x - next_move_pos.x) <= 0.7 and abs(global_position.y - next_move_pos.y) <= 0.7):
			points_to_move.remove(0)
			next_move_pos = Vector2.ZERO
	
	#resetting points to move if it reached to last point
	if points_to_move.size() == 0:
		
		#setting first point as first in points_to_move
		#as to make closed loop
		if closed_loop:
			points_to_move = points
		
		#setting first point as last in points_to_move
		#as we want to trace our way back
		else:
			cycles += 1
			if is_even(cycles):
				points_to_move = points
				cycles = 0
			else:
				points_to_move = invert(points)

#checking if supplied number is even
func is_even(i : int) -> bool:
	return (i % 2) == 0

#inverting supplied layer 
#first is last and vice versa
func invert(a : Array) -> Array:
	var b : Array
	for i in range(a.size()):
		b.append(a.pop_back())
	return b

#get variable from parent
func set_vars(a : float,b : bool) -> void:
	speed = a
	closed_loop = b
