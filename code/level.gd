extends Node2D

var magicAttack = preload("res://scenes/magicAttack.tscn")
var magicUltraAttack = preload("res://scenes/magicUltraAttack.tscn")

@onready var player = $TileMap/player

func _ready():
	Signals.connect("playerAttack", Callable(self, "_playerAttack"))

func _process(delta):
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
