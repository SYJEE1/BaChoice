extends Control  # Change this to the appropriate type (e.g., Control, Node2D)

func _ready() -> void:
	pass
	
func _on_play_pressed() -> void:
	Global.load_next_stage()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Global.load_next_stage()
