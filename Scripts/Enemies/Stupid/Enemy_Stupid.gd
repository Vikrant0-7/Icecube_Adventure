tool
extends KinematicBody2D

class_name EnemyStupid

var velocity : Vector2

var dir : Vector2

export var is_stupid : bool = true

var detect_player : bool = false
var target : Player = null
var radius : float


######################################
#                                    #
#           EDITOR LOGIC             #
#                                    #
######################################
func _get(property: String):
	if property == "can_detect_player/radius":
		return radius
	if property == "can_detect_player/detect_player":
		if detect_player and radius == 0:
			print_debug("radius must be greater than 0")
		return detect_player
	
func _set(property: String, value) -> bool:
	if property == "can_detect_player/radius":
		radius = value
		return true
	if property == "can_detect_player/detect_player":
		detect_player = value
		if detect_player and radius == 0:
			print_debug("radius must be greater than 0")
		return true
	return false

func _get_property_list():
	return [
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "can_detect_player/detect_player",
			"type": TYPE_BOOL
		},
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "can_detect_player/radius",
			"type": TYPE_REAL
		}
		
	]
