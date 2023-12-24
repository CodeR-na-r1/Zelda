extends Node2D

var magicAttack = preload("res://scenes/magicAttack.tscn")
var magicUltraAttack = preload("res://scenes/magicUltraAttack.tscn")

@onready var player = $TileMap/player

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var camera = $TileMap/player/Camera2D

func _ready():
	audio_stream_player_2d.play()
	Signals.connect("playerAttack", Callable(self, "_playerAttack"))
	
	#set-up area for enemy
	$Enemy2.min_position = Vector2(1000,500)
	$Enemy2.max_position = Vector2(2000, 1220)
	
	$Enemy3.min_position = Vector2(2000, 0)
	$Enemy3.max_position = Vector2(2700, 600)
	
	$Enemy4.min_position = Vector2(0, -1250)
	$Enemy4.max_position = Vector2(1000, -750)
	
	$Enemy5.min_position = Vector2(300, -1500)
	$Enemy5.max_position = Vector2(1300, -1000)
	
	$Enemy6.min_position = Vector2(1600, -1250)
	$Enemy6.max_position = Vector2(2600, -750)

func _process(delta):
	print(get_tree().get_nodes_in_group("Enemy").size())
	audio_stream_player_2d.position = player.position
	if not get_tree().get_nodes_in_group("Enemy").size():
		get_tree().change_scene_to_file("res://scenes/win_menu.tscn")

func _playerAttack():
	var magicAttackTemp = magicAttack.instantiate()
	if player.isSuperAttack:
		magicAttackTemp = magicUltraAttack.instantiate()
	
	magicAttackTemp.direction = player.lastDirection
	magicAttackTemp.position = Vector2(player.position.x, player.position.y)
	if player.lastDirection.x > 0:
		magicAttackTemp.position.x += 50
	elif player.lastDirection.x < 0:
			magicAttackTemp.position.x -= 50
	if player.lastDirection.y > 0:
		magicAttackTemp.position.y += 50
	elif player.lastDirection.y < 0:
		magicAttackTemp.position.y -= 50

	add_child(magicAttackTemp)

func _on_teleport_to_body_entered(body):
	if body.name == "player":
		body.position = Vector2(2310, -320)
		camera.limit_left = -400
		camera.limit_top = -1600
		camera.limit_right = 2770
		camera.limit_bottom = -175

func _on_teleport_from_body_entered(body):
	if body.name == "player":
		body.position = Vector2(2310, -95)
		camera.limit_left = -400
		camera.limit_top = -175
		camera.limit_right = 2770
		camera.limit_bottom = 1200
