extends Camera2D

@export var player_follow:Node2D

func _process(delta):
	position = player_follow.position
	

func _physics_process(delta):
	pass
