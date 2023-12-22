extends CharacterBody2D

var health	# init in _ready function
var isDead = false
@onready var healthBar = $ProgressBar

var speed = 50
var swoop_speed = 75

var last_direction = Vector2.ZERO

var animated_sprite	# init in _ready function

var direction_change_timer = 0
var direction_change_interval = 3

var swoop = false
var player = null
var player_in_range = false

var min_position = Vector2(0,0)
var max_position = Vector2(800, 430)

func _ready():
	animated_sprite = $AnimatedSprite2D
	health = healthBar.max_value
	pick_random_direction()
	add_to_group("Enemy")
	
func _physics_process(delta):
	
	update_health()
	die()
	
	if swoop:
		var direction_to_player = (player.position - position).normalized() 
		velocity = direction_to_player * swoop_speed
		update_animation(direction_to_player, true)
	else:
		direction_change_timer += delta
		if direction_change_timer >= direction_change_interval:
			pick_random_direction()
			direction_change_timer = 0
			
		velocity = last_direction * speed
		update_animation(last_direction)
	
	move_and_slide()
	
	var old_position = position
	position.x = clamp(position.x, min_position.x, max_position.x)
	position.y = clamp(position.y, min_position.y, max_position.y)	
	
	if old_position != position:	# если вышел за границы своей территории
		last_direction = -last_direction
		
func update_animation(direction, swooping=false):
	if player_in_range and swooping:
		animated_sprite.play("attack")
		animated_sprite.flip_h = direction.x > 0
		#animated_sprite.flip_v = direction.y > 0
		return
	animated_sprite.flip_h = false	
	animated_sprite.flip_v = false

	if direction.x > 0:
		animated_sprite.play("go_right")
		#animated_sprite.flip_h = direction.x < 0
	elif direction.x < 0:
		animated_sprite.play("go_left")
	elif direction.y > 0:
		animated_sprite.play("go_down")
	elif direction.y < 0:
		animated_sprite.play("go_up")
		#animated_sprite.flip_v = true	
		
func pick_random_direction():
	var new_direction = Vector2.ZERO
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	new_direction = new_direction.normalized()
	last_direction = new_direction

func update_health():
	healthBar.value = health
	healthBar.visible = health < 100

func die():
	if health <= 0 and not isDead:
		health = 0
		isDead = true
		animated_sprite.play("die")
		animated_sprite.animation_finished
		queue_free()
		
func _on_territoty_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		swoop = true

func _on_territoty_body_exited(body):
	if body.is_in_group("Player"):
		player = null
		swoop = false
		pick_random_direction()
		update_animation(last_direction)
	
func _on_hitbox_enemy_1_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		print("Swooping")
		#animated_sprite.flip_v = position.y > body.position.y
		animated_sprite.flip_h = position.x > body.position.x
		swoop_speed = 0
		health -= 20
		body.health -= 20


func _on_hitbox_enemy_1_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player exited the hitbox!")
		animated_sprite.flip_v = false
		animated_sprite.flip_h = false
		swoop_speed = 75
