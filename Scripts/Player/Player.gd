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

func is_on_platform() -> bool:
	$Raycast/left.force_raycast_update()
	$Raycast/right.force_raycast_update()
	
	var l = $Raycast/left.get_collider()
	var r = $Raycast/right.get_collider()
	
	if $Raycast/left.is_colliding():
		platform_velocity = $Raycast/left.get_collider().velocity
	elif $Raycast/right.is_colliding():
		platform_velocity = $Raycast/right.get_collider().velocity
	else:
		platform_velocity = 0
	
	return $Raycast/left.is_colliding() or $Raycast/right.is_colliding()
