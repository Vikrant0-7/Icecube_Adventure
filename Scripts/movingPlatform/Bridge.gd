extends Line2D

onready var moving_body : MovingPlatform = get_node("MovingPlatform")

export var speed : float = 100
export var closed_loop : bool = false
export var debug : bool = false

func _ready() -> void:
	moving_body.set_vars(speed,closed_loop,debug)
