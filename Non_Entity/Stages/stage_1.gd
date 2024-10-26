extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel

var quota: float = 700
var stage_num: String = "1"
var customers: int = 10
var order_function = "tutorial"

signal updates_completed

var dialogue = "res://Non_Entity/Dialogue/tutorial.dialogue"


func _ready() -> void:
	Engine.max_fps = 60
	Global.get_max_customers(customers)
	Global.get_quota(quota)
	Global.get_stage_num(stage_num)
	Global.get_order(order_function)
	Global.get_total_customers(customers)
	print(Global.get_max_customers(customers))
	print(Global.get_total_customers(customers))
	emit_signal("updates_completed")
	Global.connect("total_customers_updated", Callable(self, "checking_condition"))
	#Global.get_dialogue(dialogue)
	

# func _process(delta: float) -> void:
	# fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
	
