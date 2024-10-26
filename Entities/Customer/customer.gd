extends CharacterBody2D

@export var spawn_point: Node2D
var order: Dictionary = {}
var order_system: Node
var progress_bar: Node
var timer: Timer
var nearby_item: RigidBody2D = null
@onready var area: Area2D = $ReceivingArea
var paid: float = 0
@export var order_info: Dictionary

signal removed
signal order_completed(amount_paid)
signal order_info_updated(order_info)

var audio_stream_player: AudioStreamPlayer
var spawn_sound: AudioStream
var spawn_volume_db: float = -25.0

func _ready():
	var order_system_scene: PackedScene = load("res://Entities/Customer/Order/order_system.tscn")
	order_system = order_system_scene.instantiate()
	add_child(order_system)
	
	var order_function_name = Global.send_order() 
	var order = order_system.call(order_function_name)
	
	order_system.display_order(order)
	
	var order_info = order_system.combined_order_info(order)
	emit_signal("order_info_updated", order_info)
	
	paid = order_system.calculate_total_price(order)

	var progress: PackedScene = load("res://Entities/Customer/customer_timer.tscn")
	progress_bar = progress.instantiate()
	add_child(progress_bar)

	timer = Timer.new()
	timer.wait_time = 90
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()
	
func finish_order():
	if order_system:
		var price = 1.0

		if timer:
			var elapsed_time = timer.wait_time - timer.time_left
			if elapsed_time <= 45:
				price = 1
			elif elapsed_time <= 60:
				price = 0.9
			elif elapsed_time <= 75:
				price = 0.8
			elif elapsed_time == 90:
				price = 0.0

			var amount_paid = paid * price

			# Set the amount paid in the global script
			Global.set_amount_paid(amount_paid)
			
		order_system.queue_free()
	emit_signal("removed", self)
	queue_free()

func _on_timer_timeout():
	finish_order()
