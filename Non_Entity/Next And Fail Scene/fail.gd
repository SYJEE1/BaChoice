extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_try_again_pressed() -> void:
	#change the file path to the current scene 
	get_tree().change_scene_to_file("res://Non_Entity/Stages/Stage1.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Non_Entity/Menu Scene/menu.tscn")
