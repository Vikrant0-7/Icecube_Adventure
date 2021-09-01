tool
extends KinematicBody2D

class_name Player

var dir : Vector2

var velocity : Vector2

enum POWER_UP_TYPE{
	STAMINA,
	MID_AIR_JUMP,
	WALL_JUMP,
	JET_FUEL,
	JET_POWER,
	SPRINT_FATIGUE,
	MID_AIR_POWER_REDUCTION
}

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
	if not Engine.editor_hint:
		get_input()

func lit() -> void:
	print("yeh")

func apply_power_up(type : int,parameter : float) -> void:
	if type == POWER_UP_TYPE.STAMINA:
		$State_Machine/Run.stamina += parameter
	if type == POWER_UP_TYPE.JET_FUEL:
		$State_Machine/Air.can_jet = true
		$State_Machine/Jet.propultion_duration += parameter
	if type == POWER_UP_TYPE.MID_AIR_JUMP:
		$State_Machine/Air.can_double_jump = true
		$State_Machine/Air.max_jumps += int(parameter)
	if type == POWER_UP_TYPE.WALL_JUMP:
		$State_Machine/Air.can_wall_jump = true
	if type == POWER_UP_TYPE.SPRINT_FATIGUE:
		$State_Machine/Run.sprint_tiredness += parameter
	if type == POWER_UP_TYPE.JET_POWER:
		$State_Machine/Jet.speed += Vector2(parameter,parameter)
	if type == POWER_UP_TYPE.MID_AIR_POWER_REDUCTION:
		$State_Machine/Air.jump_power_reduction += parameter


######################################
#                                    #
#           EDITOR LOGIC             #
#                                    #
######################################

#run variables
var SPEED : float
var acceleration : float
var friction :float
var SPRINT_SPEED : float
var sprint_stamina : float
var sprint_tiredness : float
var sprint_acceleration : float = 0.0

#Air variables
var max_jumps : int
var jump_height : float
var time_to_peak : float
var time_to_descent : float  
var drag : float
var can_jet : bool = false 
var can_double_jump : bool = false
var can_wall_jump : bool = false

#jet variables
var time_to_react : float
var propultion_duration : float
var speed: Vector2

#wall jump variables
var WALL_JUMP_FORCE : float
var no_control_state : float
var  WALL_GRAVITY : float




func _get(property: String):
	
	#run
	if property == "Run/SPEED":
		return SPEED
	if property == "Run/acceleration":
		return acceleration
	if property == "Run/friction":
		return friction
	if property == "Run/SPRINT_SPEED":
		return SPRINT_SPEED
	if property == "Run/sprint_stamina":
		return sprint_stamina
	if property == "Run/sprint_tiredness":
		return sprint_tiredness
	if property == "Run/sprint_acceleration":
		return sprint_acceleration
	
	#air
	if property == "Air/max_jumps":
		return max_jumps
	if property == "Air/jump_height":
		return jump_height
	if property == "Air/time_to_peak":
		return time_to_peak
	if property == "Air/time_to_descent":
		return time_to_descent
	if property == "Air/drag":
		return drag
	if property == "Air/can_jet":
		return can_jet
	if property == "Air/can_double_jump":
		return can_double_jump
	if property == "Air/can_wall_jump":
		return can_wall_jump
	
	#jet
	if property == "Jet/time_to_react":
		return time_to_react
	if property == "Jet/propultion_duration":
		return propultion_duration
	if property == "Jet/speed":
		return speed
	
	#wall jump
	if property == "Wall_Jump/Wall_Gravity":
		return WALL_GRAVITY
	if property == "Wall_Jump/Jump_force":
		return WALL_JUMP_FORCE
	if property == "Wall_Jump/Controls_Disabled":
		return no_control_state

func _set(property: String, value) -> bool:

	#run
	if property == "Run/SPEED":
		SPEED = value
		return true
	if property == "Run/acceleration":
		acceleration = value
		return true
	if property == "Run/friction":
		friction = value
		return true
	if property == "Run/SPRINT_SPEED":
		SPRINT_SPEED = value
		return true
	if property == "Run/sprint_stamina":
		sprint_stamina = value
		return true
	if property == "Run/sprint_tiredness":
		sprint_tiredness = value
		return true
	if property == "Run/sprint_acceleration":
		sprint_acceleration = value
		return true

	#air
	if property == "Air/max_jumps":
		max_jumps = value
		return true
	if property == "Air/jump_height":
		jump_height = value
		return true
	if property == "Air/time_to_peak":
		time_to_peak = value
		return true
	if property == "Air/time_to_descent":
		time_to_descent = value
		return true
	if property == "Air/drag":
		drag = value
		return true
	if property == "Air/can_jet":
		can_jet = value
		return true
	if property == "Air/can_double_jump":
		can_double_jump = value
		return true
	if property == "Air/can_wall_jump":
		can_wall_jump = value
		return true
	
	#jet
	if property == "Jet/time_to_react":
		time_to_react = value
		return true
	if property == "Jet/propultion_duration":
		propultion_duration = value
		return true
	if property == "Jet/speed":
		speed = value
		return true
	
	#wall jump
	if property == "Wall_Jump/Wall_Gravity":
		WALL_GRAVITY = value
		return true
	if property == "Wall_Jump/Jump_force":
		WALL_JUMP_FORCE = value
		return true
	if property == "Wall_Jump/Controls_Disabled":
		no_control_state = value
		return true
	
	return false

func _get_property_list() -> Array:
	return[
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/SPEED",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,1,0.02",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/acceleration",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,1,0.02",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/friction",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,20,0.5",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/SPRINT_SPEED",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,1,0.04",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/sprint_acceleration",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,20,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/sprint_stamina",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,5,0.2",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Run/sprint_tiredness",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,6,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/jump_height",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,2,0.05",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/time_to_peak",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,2,0.05",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/time_to_descent",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,0.5,0.01",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/drag",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,5,1",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/max_jumps",
			"type": TYPE_INT
		},
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/can_jet",
			"type": TYPE_BOOL
		},
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/can_double_jump",
			"type": TYPE_BOOL
		},
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Air/can_wall_jump",
			"type": TYPE_BOOL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,2,0.25",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Jet/time_to_react",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,20,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Jet/propultion_duration",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "0,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Jet/speed",
			"type": TYPE_VECTOR2
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Wall_Jump/Wall_Gravity",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Wall_Jump/Jump_force",
			"type": TYPE_REAL
		},
		{
			"hint": PROPERTY_HINT_RANGE,
			"hint_string" : "1,10,0.5,or_greater",
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "Wall_Jump/Controls_Disabled",
			"type": TYPE_REAL
		}
		
	]

