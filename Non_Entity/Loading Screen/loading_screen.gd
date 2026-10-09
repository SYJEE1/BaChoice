extends Control

var progress = []
var TUTORIAL
var TUTORIAL_load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TUTORIAL = "res://Non_Entity/Stages/Stage1.tscn"
	ResourceLoader.load_threaded_request(TUTORIAL)
	
func _process(delta):
	TUTORIAL_load_status = ResourceLoader.load_threaded_get_status(TUTORIAL, progress)
	$countDown.text = str(floor(progress[0] * 100)) + "%"

	match TUTORIAL_load_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			var newScene = ResourceLoader.load_threaded_get(TUTORIAL)
			if newScene:
				get_tree().change_scene_to_file(TUTORIAL)
			else:
				push_error("Failed to load the stage scene.")
		
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Loading failed. Please check the stage path or resource.")
