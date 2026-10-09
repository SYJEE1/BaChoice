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

const PATIENCE: float = 150.0 # seconds a customer waits before leaving (2 min 30 s)

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
	timer.wait_time = PATIENCE
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()
	
func finish_order(served: bool = true):
	if order_system:
		var amount_paid = 0.0
		if served:
			if Global.fixed_payout > 0:
				# this stage pays a flat amount no matter how long the customer waited
				amount_paid = Global.fixed_payout
			else:
				amount_paid = paid * _patience_multiplier()

		# Set the amount paid in the global script
		Global.set_amount_paid(amount_paid)
		order_system.queue_free()
	emit_signal("removed", self)
	queue_free()

# full pay for the first half of the wait, then 90%, 80%, 70%
func _patience_multiplier() -> float:
	if timer == null: return 1.0
	var elapsed_time = timer.wait_time - timer.time_left
	if elapsed_time <= PATIENCE * 0.5: return 1.0
	elif elapsed_time <= PATIENCE * 2.0 / 3.0: return 0.9
	elif elapsed_time <= PATIENCE * 5.0 / 6.0: return 0.8
	return 0.7

func _on_timer_timeout():
	finish_order(false) # left without being served: pays nothing
