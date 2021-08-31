tool
extends KinematicBody2D

class_name EnemyStupid

var velocity : Vector2

var dir : Vector2

export var is_stupid : bool = true
export (float,1,10,0.5)var gravity
export (float,1,10,0.5)var patrol_speed

var detect_player : bool = false
var target : Player = null
var radius : float
var chase_distance : float
var chase_speed : float


######################################
#                                    #
#           EDITOR LOGIC             #
#                                    #
######################################
func _get(property: String):
	if property == "can_detect_player/radius":
		return radius
	if property == "can_detect_player/detect_player":
		return detect_player
	if property == "can_detect_player/chase_distance":
		return chase_distance
	if property == "can_detect_player/chase_speed":
		return chase_speed
	
func _set(property: String, value) -> bool:
	if property == "can_detect_player/radius":
		radius = value 
		return true
	if property == "can_detect_player/detect_player":
		detect_player = value
		return true
	if property == "can_detect_player/chase_distance":
		chase_distance = value
		return true
	if property == "can_detect_player/chase_speed":
		chase_speed = value
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
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "can_detect_player/radius",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "can_detect_player/chase_distance",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "can_detect_player/chase_speed",
			"type": TYPE_REAL
		}
	]
