extends CanvasLayer


func _on_play_yes_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")


func _on_play_no_pressed():
	get_tree().change_scene_to_file("res://scenes/startscreen.tscn")
