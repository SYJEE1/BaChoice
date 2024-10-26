extends Control

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
func paused():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		paused()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		

# Called when the node enters the scene tree for the first time.$PanelContainer
func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().quit

func _on_restart_pressed():
	get_tree().paused = false
	Global.reload_stage()
	
	
func _process(delta):
	testEsc()
