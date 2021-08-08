#check_floor.gd
extends Node

class_name CheckFloor

onready var g1 := get_node("ground")
onready var g2 := get_node("ground2")

func check_floor() -> bool:
	g1.enabled = true
	g2.enabled = true
	g1.force_raycast_update()
	g2.force_raycast_update()
	return (g1.is_colliding() or g2.is_colliding())
