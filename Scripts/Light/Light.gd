extends Light2D


export var time_period : float
onready var ray : RayCast2D = $RayCast2D
onready var player : Player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	ray.cast_to = Vector2(0,(texture.get_size()/3).length() * texture_scale)

func _physics_process(delta: float) -> void:
	ray.rotation_degrees = rad2deg((player.global_position - global_position).angle()) - 90
	
	if ray.is_colliding():
		var a = ray.get_collider()
		if a.has_method("lit"):
			a.lit()
