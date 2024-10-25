extends Control  # Change this to the appropriate type (e.g., Control, Node2D)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Non_Entity/Stages/Stage1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
