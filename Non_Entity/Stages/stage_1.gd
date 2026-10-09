extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel

var quota: float = 300
var stage_num: String = "1"
var customers: int = 1
var payout: float = 300 # paid for a served order no matter how long the customer waited; 0 = use the order price and patience
var order_function = "tutorial"

signal updates_completed

var dialogue = "res://Non_Entity/Dialogue/tutorial.dialogue"


func _ready() -> void:
	Engine.max_fps = 60
	Global.reset_amount_paid()
	Global.game_running = false
	Global.get_max_customers(customers)
	Global.get_quota(quota)
	Global.fixed_payout = payout
	Global.get_stage_num(stage_num)
	Global.get_order(order_function)
	Global.get_total_customers(0)  # no customers have arrived yet
	emit_signal("updates_completed")
	#Global.get_dialogue(dialogue)
	

# func _process(delta: float) -> void:
	# fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
	
