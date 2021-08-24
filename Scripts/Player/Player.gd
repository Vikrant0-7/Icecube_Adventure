extends KinematicBody2D

class_name Player

var dir : Vector2

var velocity : Vector2

var platform_velocity


#to get input from users
func get_input() -> void:
	dir = Vector2.ZERO
	
	if Input.is_action_pressed("Left"):
		dir.x -= 1
	elif Input.is_action_pressed("Right"):
		dir.x += 1
	
	if Input.is_action_pressed("Jump"):
		dir.y -= 1
	elif Input.is_action_pressed("duck"):
		dir.y += 1


func _physics_process(delta : float):
	get_input()

func lit() -> void:
	print("yeh")

