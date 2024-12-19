extends CharacterBody2D


const SPEED = 3500.0
var current_dir = "None"


func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta:float):
	var SpeedR = SPEED * delta
	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += SpeedR
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SpeedR
	if Input.is_action_pressed("ui_down"):
		velocity.y += SpeedR
	if Input.is_action_pressed("ui_up"):
		velocity.y -= SpeedR

	# Normaliza la velocidad para mantener una velocidad constante al moverse en diagonal
	if velocity.length() > 0:
		velocity = velocity.normalized() * SpeedR

	# Cambia la dirección actual según el vector de velocidad
	if velocity.x > 0:
		current_dir = "right"
	elif velocity.x < 0:
		current_dir = "left"
	elif velocity.y > 0:
		current_dir = "down"
	elif velocity.y < 0:
		current_dir = "up"

	# Animación
	if velocity != Vector2.ZERO:
		play_anim(1)
	else:
		play_anim(0)
	
	move_and_slide()

func play_anim(movement:int):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	anim.flip_h = true
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	
	elif dir == "left":
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
	
	elif dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
	
	elif dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")
