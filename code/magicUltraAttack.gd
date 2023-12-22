extends Area2D

var lifeTimeTimer	# init in _ready function
var LIFETIME = 2 # seconds

var hasTarget = false
var target = null

var SPEED = 4
var direction = null

func _ready():
	hasTarget = false
	lifeTimeTimer = Time.get_unix_time_from_system()
	if direction == null:
		direction = Vector2(1, 0)

func _process(delta):
	
	if hasTarget:
		direction = (target.position - position).normalized()

	self.position.x += SPEED *direction.x
	self.position.y += SPEED *direction.y
	
	if Time.get_unix_time_from_system() - lifeTimeTimer > LIFETIME:
		kill()

func _on_detector_body_entered(body):
	if not hasTarget and body.is_in_group("Enemy"):
		print("setTarget")
		hasTarget = true
		target = body

func _on_detector_body_exited(body):
	if hasTarget and body.name == target.name:
		print("!!!unsetTarget")
		hasTarget = false
		target = null

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= 15
		kill()
		
func kill():
		Vars.magicCounter -= 1
		queue_free()
