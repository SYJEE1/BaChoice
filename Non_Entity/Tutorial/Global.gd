# In Global.gd
extends Node

# For Scores

var amount_paid: float = 0.0
var total_earnings: float = 0.0
var new_quota: float = 0.0
var stage_number: String = ""
var max_total_customers: int = 0
var total_spawned_customers: int = 0
var stage1_scene = preload("res://Non_Entity/Stages/Stage1.tscn")
var new_order: String = ""
var has_item: bool = false
var current_item_frame: int = 1
var current_item_animation: String = ""

signal item_state_changed(state: bool) 
signal amount_paid_changed(new_amount: float)
signal new_stage_number(stage_number: String)
signal max_customers(customers: int)
signal new_ordersystem(order: String)
signal total_customers_updated

func _ready () -> void:
	var stage1 = stage1_scene.instantiate()
	get_tree().current_scene.add_child(stage1)
	stage1.connect("updates_completed", Callable (self, "_on_updates_completed"))
	stage1.queue_free()  
	get_quota(new_quota)
	send_quota()
	send_max_customers()
	get_max_customers(max_total_customers)
	get_order(new_order)
	send_order()
	
	

func _on_updates_completed() -> void:
	send_quota()  # Call the function to send the quota
	send_stage_num()  # Call the function to send the stage number

func checking_condition():
	var total = send_total_customers()
	var max = send_max_customers()
	var total_earnings = get_amount_paid()
	var total_max_earnings = 1500
	if total >= max:
		if new_quota < total_earnings or total_earnings == max_total_customers:
			get_tree().change_scene_to_file("res://Non_Entity/Next And Fail Scene/next.tscn")
		elif new_quota > total_earnings:
			get_tree().change_scene_to_file("res://Non_Entity/Next And Fail Scene/Fail.tscn")

# Quota
func get_quota(quota: float):
	if quota != new_quota:  # Only update if there's a change
		new_quota = quota
		return new_quota
func send_quota() -> float:
	return new_quota
# Customers
func get_max_customers(customers: int):
	if customers != max_total_customers:  # Only update if there's a change
		max_total_customers = customers
		print (max_total_customers)
		return max_total_customers
func send_max_customers() -> float:
	return max_total_customers
	
func get_total_customers(customers: int):
	if customers != total_spawned_customers:  # Only update if there's a change
		total_spawned_customers = customers
		return total_spawned_customers
		emit_signal("total_customers_updated")
func send_total_customers() -> float:
	return total_spawned_customers

# Order Scene
func get_order(order: String):
	if order != new_order:  # Only update if there's a change
		new_order = order
		emit_signal("new_ordersystem", new_order)
		return new_order
func send_order() -> String:
	return new_order
# Getting Stage Number
func get_stage_num(new_stage_num: String):
	if new_stage_num != stage_number:
		stage_number = new_stage_num
		emit_signal("new_stage_number", stage_number)
		return new_stage_num
func send_stage_num() -> String:
	return stage_number
# Earnings
func set_amount_paid(new_amount_paid: float):
	amount_paid += new_amount_paid
	emit_signal("amount_paid_changed", amount_paid)  # Notify listeners
func get_amount_paid() -> float:
	return amount_paid
# For Giving Orders to Customers
func update_item_state(state: bool):
	has_item = state
	emit_signal("item_state_changed", state)  # Notify listeners
func get_item_state() -> bool:
	return has_item
# Getting the correct frame for orders
func get_current_animation(new_animation: String):
	current_item_animation = new_animation
	print ("current animation",current_item_animation )
	return current_item_animation

func send_current_animation() -> String:
	return current_item_animation

func get_current_frame(new_frame: float):
	current_item_frame = new_frame
	return current_item_frame
func send_current_frame() -> int:
	return current_item_frame
