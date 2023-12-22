extends CharacterBody2D

var speed = 50
var swoop_speed = 75
var last_direction = Vector2.ZERO
var animated_sprite
var direction_change_timer = 0
var direction_change_interval = 5
var swoop = false
var player = null
var player_in_range = false

var min_position = Vector2(0,0)
var max_position = Vector2(800, 430)

func _ready():
	animated_sprite = $AnimatedSprite2D
	pick_random_direction()
	
func _physics_process(delta):
	direction_change_timer += delta
	if direction_change_timer >= direction_change_interval:
		pick_random_direction()
		direction_change_timer = 0
		
	velocity = last_direction * speed
	
	animated_sprite.flip_h = false
	animated_sprite.flip_v = false
	
	if last_direction.x > 0:
		animated_sprite.play("walk_right")
	elif last_direction.x < 0:
		animated_sprite.play("walk_left")
	elif last_direction.y > 0:
		animated_sprite.play("walk_down")
	elif last_direction.y < 0:
		animated_sprite.play("walk_up")
		animated_sprite.flip_v = true
		
	var old_position = position
	position.x = clamp(position.x, min_position.x, max_position.x)
	position.y = clamp(position.y, min_position.y, max_position.y)	
	
	if old_position != position:
		last_direction = -last_direction
		
func pick_random_direction():
	var new_direction = Vector2.ZERO
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	new_direction = new_direction.normalized()
	last_direction = new_direction

func _on_hitbox_enemy_3_body_entered(body):
	pass # Replace with function body.

func _on_hitbox_enemy_3_body_exited(body):
	pass # Replace with function body.


func _on_territory_body_entered(body):
	pass # Replace with function body.


func _on_territory_body_exited(body):
	pass # Replace with function body.
