extends Area2D

enum EFFECT{
	ADD = 1,
	SUB = -1
}

enum POWER_UP_TYPE{
	STAMINA,
	MID_AIR_JUMP,
	WALL_JUMP,
	JET_FUEL,
	JET_POWER,
	SPRINT_FATIGUE,
	MID_AIR_POWER_REDUCTION
}

export (POWER_UP_TYPE) var power_up_type

export (EFFECT) var effect

export (float) var parameter

func _process(delta: float) -> void:
	print(effect)


func _on_PowerUp_body_entered(body: Player) -> void:
	if body is Player:
		body.apply_power_up(power_up_type, parameter * effect)
		queue_free()
