extends Area2D

var lifeTimeTimer	# init in _ready function
var LIFETIME = 1.5 # seconds

var SPEED = 3
var direction = null

func _ready():
	lifeTimeTimer = Time.get_unix_time_from_system()
	if direction == null:
		direction = Vector2(1, 0)

func _process(delta):
	
	self.position.x += SPEED *direction.x
	self.position.y += SPEED *direction.y
	
	if Time.get_unix_time_from_system() - lifeTimeTimer > LIFETIME:
		kill()

func _on_body_entered(body):
	print("here")
	if body.is_in_group("Enemy"):
		body.health -= 15
		kill()
		
func kill():
		Vars.magicCounter -= 1
		queue_free()
