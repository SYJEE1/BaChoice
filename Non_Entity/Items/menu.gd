extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://Non_Entity/Stages/Stage1.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Non_Entity/Stages/Stage1.tscn")
	
	if event.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://Non_Entity/Stages/Stage1.tscn")

func _on_option_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
