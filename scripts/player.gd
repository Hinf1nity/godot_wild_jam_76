extends CharacterBody2D

@onready var healthbar = $Interface/HealthBar
@onready var expbar = $Interface/ExpBar

const SPEED = 50
var current_dir = "None"

var health = 100
var player_alive = true

var experiencia = 0

var attack_ip = false
var damage = 20
var ray_range = RayCast2D

func _ready() -> void:
	health = 100
	experiencia = 0
	healthbar.init_health(health)
	expbar.init_exp(experiencia, 100.0)

func _physics_process(delta: float) -> void:
	player_movement(delta)
	attack()
	if health <= 0:
		player_alive = false
		health = 0
		print("Player has been kill")
		self.queue_free()

func player_movement(delta: float):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		current_dir = "right"
		ray_range = $ray_right
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		current_dir = "left"
		ray_range = $ray_left
	if Input.is_action_pressed("move_down"):
		velocity.y += SPEED
		current_dir = "down"
		ray_range = $ray_down
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
		current_dir = "up"
		ray_range = $ray_up

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		play_anim(1)
	else:
		play_anim(0)

	move_and_collide(velocity * delta)

func play_anim(movement: int) -> void:
	var dir = current_dir
	var anim = $AnimatedSprite2D
	anim.flip_h = true

	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if not attack_ip:
				anim.play("side_idle")
	elif dir == "left":
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if not attack_ip:
				anim.play("side_idle")
	elif dir == "down":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if not attack_ip:
				anim.play("front_idle")
	elif dir == "up":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if not attack_ip:
				anim.play("back_idle")

func player() -> void:
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	pass

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	pass

func attack() -> void:
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		elif dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		elif dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		elif dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
		if ray_range.is_colliding():
			var collider = ray_range.get_collider()
			if collider.is_in_group("Enemies"):
				collider.take_damage(damage)

func take_damage(amount: int) -> void:
	health -= amount
	print("Salud restante: ", health)
	if health <= 0:
		die()
	healthbar.health = health

func set_exp(amount: int) -> void:
	experiencia += amount
	print("Incremento de experiencia: ", experiencia)
	expbar.experiencia = experiencia

func die() -> void:
	print("¡Has muerto!")
	queue_free()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
