extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel

var quota: float = 200 # original is 560
var earnings: float = 0.0
var stage_num: String = "1"
var customers: int = 3 # original is 10
var order_function = "stage1_order"
var dialogue = "res://Non_Entity/Dialogue/tutorial.dialogue"

signal updates_completed

func _ready() -> void:
	Engine.max_fps = 60
	emit_signal("updates_completed", quota, stage_num, customers, order_function, earnings)
	Global.connect("total_customers_updated", Callable(self, "checking_condition"))
	

# func _process(delta: float) -> void:
	# fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
	
