extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel
var game_running : bool
func _ready() -> void:
	Engine.max_fps = 60

func _process(delta: float) -> void:
	fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
