class_name StupidState

extends State

var Self : EnemyStupid

func _ready() -> void:
	yield(owner,"ready")
	
	Self = owner as EnemyStupid
	
	assert(Self != null)
