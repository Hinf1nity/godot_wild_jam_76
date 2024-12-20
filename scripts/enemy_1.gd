extends CharacterBody2D

@onready var healthbar = $HealthBar

var speed = 35
var player_chase = false
var player = null
var player_hit = null
var min_distance = 15

var damage = 10
var health = 100
var experiencia = 50

var is_dying = false

func _ready() -> void:
	health = 100
	healthbar.init_health(health)

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	if player_chase and player:
		var direction = player.position - position
		var distance = direction.length()
		
		if distance > min_distance:
			var movement = direction.normalized() * speed
			var collision = move_and_collide(movement * delta)
			
			if collision:
				adjust_movement_on_collision(collision, movement, delta)
				
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = movement.x < 0
			
		else:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("idle")
		
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")

func adjust_movement_on_collision(collision: KinematicCollision2D, movement: Vector2, delta: float):
	# Calcula la dirección perpendicular a la superficie de colisión
	var normal = collision.get_normal()
	var slide_direction = movement.slide(normal)
	move_and_collide(slide_direction * delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	player_chase = true
	player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy() -> void:
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_hit = body
		$take_damage_cooldown.start()


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_hit = null
		$take_damage_cooldown.stop()
		
func deal_damage() -> void:
	if player_hit:
		player.take_damage(damage)

func _on_take_damage_cooldown_timeout() -> void:
	deal_damage()
	
func take_damage(amount: int) -> void:
	health -= amount
	print("Enemigo dañado, salud restante: ", health)
	if health <= 0:
		velocity = Vector2.ZERO
		die()
	healthbar.health = health

func die() -> void:
	if is_dying:
		return
	is_dying = true
	print("Enemigo eliminado")
	player.set_exp(experiencia)
	$enemy_hitbox/CollisionShape2D.disabled = true
	$take_damage_cooldown.stop()
	$AnimatedSprite2D.play("death")
	$CollisionShape2D.disabled = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		queue_free()
