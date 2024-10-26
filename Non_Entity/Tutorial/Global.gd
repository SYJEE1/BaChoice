# In Global.gd
extends Node

# For Scores

var amount_paid: float = 0.0
var total_earnings: float = 0.0
var new_quota: float = 0.0
var initial_earnings: float = 0.0
var stage_number: String = ""
var max_total_customers: int = 0
var total_spawned_customers: int = 0
var new_order: String = ""
var new_stage: String = ""
var has_item: bool = false
var current_item_frame: int = 1
var current_item_animation: String = ""
var price: float
var current_stage_instance: Node = null

var stage_paths = {
	"tutorial": "res://Non_Entity/Stages/Tutorial/Tutorial.tscn",
	"stage1": "res://Non_Entity/Stages/Stage1/Stage1.tscn",
	"stage2": "res://Non_Entity/Stages/Stage2/Stage2.tscn",
}
var current_stage_index: int = 0
var stage_keys: Array = []
var stage_history: Array = []
var countdown_time: float = 120.0  # Total countdown time in seconds
var elapsed_time: float = 0.0  # Time elapsed since the last check
var level_completed: bool = false 

signal price_updated(price: float)
signal item_state_changed(state: bool) 
signal amount_paid_changed(new_amount: float)
signal reset_earnings(initial_earnings: float)
signal new_stage_number(stage_number: String)
signal max_customers(customers: int) 
signal new_ordersystem(order: String)
signal total_customers_updated

func _ready () -> void:
	stage_keys = stage_paths.keys()
	connect("amount_paid_changed", Callable (self, "checking_condition"))
	
func load_next_stage() -> void:
	if current_stage_index < stage_keys.size():
		# Store the current stage index in history before loading the new one
		if current_stage_index >= 0:  # Ensure we don't add an invalid index
			stage_history.append(current_stage_index)

		var stage_key = stage_keys[current_stage_index]
		var stage_path = stage_paths[stage_key]  # Get the path of the current stage

		# Load the new stage
		var stage_scene = load(stage_path)  # Load the scene resource
		var new_stage_instance = stage_scene.instantiate()  # Instantiate the scene

		# Connect any necessary signals here
		new_stage_instance.connect("updates_completed", Callable(self, "_on_updates_completed"))
		# You can connect other signals as needed
		# Add the new stage instance to the current scene
		add_child(new_stage_instance)
		new_stage_instance.queue_free()
		
		# Change to the new scene
		var result = get_tree().change_scene_to_file(stage_path)
		emit_signal("reset_earnings", initial_earnings)
		if result == OK:
			print("Changed to scene: ", stage_path)
		else:
			print("Failed to change scene to: ", stage_path)

		# Increment the stage index for the next call
		current_stage_index += 1
	else:
		print("No more stages to load.")

func load_previous_stage() -> void:
	if stage_history.size() > 0:
		# Remove the last stage from the history
		var previous_stage_index = stage_history.pop_back()  # Get the last stage index

		# Change to the previous stage
		load_stage(previous_stage_index)  # Load the previous stage
	else:
		print("No previous stage available. Staying on the current stage.")

func reload_stage() -> void:
	var reload_index = -1
	print("reload attempt")
	if current_stage_index:
		reload_index += current_stage_index
		var stage_key = stage_keys[reload_index]
		var stage_path = stage_paths[stage_key]  # Get the path of the current stage

		# Load the new stage
		var stage_scene = load(stage_path)  # Load the scene resource
		var new_stage_instance = stage_scene.instantiate()  # Instantiate the scene

		# Connect any necessary signals here
		new_stage_instance.connect("updates_completed", Callable(self, "_on_updates_completed"))
		# You can connect other signals as needed

		# Add the new stage instance to the current scene
		add_child(new_stage_instance)
		new_stage_instance.queue_free()
		# Change to the new scene
		var result = get_tree().change_scene_to_file(stage_path)
		emit_signal("reset_earnings", initial_earnings)
		if result == OK:
			print("Changed to scene: ", stage_path)
		else:
			print("Failed to change scene to: ", stage_path)

		# Increment the stage index for the next call
	else:
		print("No more stages to load.")

func load_stage(index: int) -> void:
	if index < stage_keys.size():
		var stage_key = stage_keys[index]
		var stage_scene = load(stage_paths[stage_key])  # Load the specified stage
		var stage_instance = stage_scene.instantiate()  # Instantiate the scene
		add_child(stage_instance)  # Add it to the current scene
		# Connect the signal from the instantiated stage
		stage_instance.connect("updates_completed", Callable(self, "_on_updates_completed"))
		stage_instance.queue_free()
	else:
		print("Invalid stage index.")
	load_next_stage()
	

func _on_updates_completed(quota, stage_num, customers, order_function, earnings):
	print("this is stage is: ", stage_num)
	get_quota(quota)
	get_max_customers(customers)
	get_order(order_function)
	get_stage_num(stage_num)
	get_inital_earnings(earnings)
	print("next stage received earnings is: ", get_inital_earnings(earnings))
	send_quota()
	send_max_customers()
	send_order()
	send_stage_num()  
	send_inital_earnings()  
	print("next stage sent earnings is: ", send_inital_earnings()  )

func checking_condition():
	var total = send_total_customers()
	print(total)
	var max = send_max_customers()
	print(max)
	var total_earnings = get_amount_paid()
	print(new_quota)
	print(total_earnings)
	print(amount_paid)
	var total_max_earnings = 1500
	if total == max:
		elapsed_time = 0.0
		if new_quota < total_earnings:
			get_tree().change_scene_to_file("res://Non_Entity/Next And Fail Scene/next.tscn")
			print ("Level Complete")
			level_completed = true
		else:
			print("Waiting for timer...")
	else: 
		print ("Level not yet finished")

func _process(delta):
	if not level_completed:
		# Increment the elapsed time by the delta time
		elapsed_time += delta
		
		# Check if the elapsed time exceeds the countdown time
		if elapsed_time >= countdown_time:
			var total_earnings = get_amount_paid()
			print("Timer finished. Checking earnings...")
			
			if new_quota > total_earnings:
				get_tree().change_scene_to_file("res://Non_Entity/Next And Fail Scene/Fail.tscn")
				print("Level Failed")
			else:
				get_tree().change_scene_to_file("res://Non_Entity/Next And Fail Scene/next.tscn")
				print("Level Complete after timer")
			level_completed = true  # Mark the level as completed

# Getting Stage Path
func get_stage(stage: String):
	if stage != new_stage:  # Only update if there's a change
		new_stage = stage
		emit_signal("new_ordersystem", new_stage)
		return new_stage
		
func send_stage() -> String:
	return new_stage

# Quota
func get_quota(quota: float):
	new_quota = quota
	return new_quota
func send_quota() -> float:
	return new_quota

# Initalizing Earings
func get_inital_earnings(earnings: float):
	initial_earnings = earnings
	return initial_earnings
func send_inital_earnings() -> float:
	return initial_earnings

# Customers
func get_max_customers(customers: int):
	max_total_customers = customers
	return max_total_customers
func send_max_customers() -> float:
	return max_total_customers
	
func get_total_customers(customers: int):
	total_spawned_customers = customers
	return total_spawned_customers
	emit_signal("total_customers_updated")

func send_total_customers() -> float:
	return total_spawned_customers

# Order Scene
func get_order(order: String):
	new_order = order
	emit_signal("new_ordersystem", new_order)
	return new_order
		
func send_order() -> String:
	return new_order

# Getting Stage Number
func get_stage_num(new_stage_num: String):
	stage_number = new_stage_num
	emit_signal("new_stage_number", stage_number)
	return new_stage_num
	
func send_stage_num() -> String:
	return stage_number
	
# Earnings
func set_amount_paid(new_amount_paid: float):
	amount_paid += new_amount_paid
	emit_signal("amount_paid_changed", amount_paid)  # Notify listeners
	checking_condition()
	
func get_amount_paid() -> float:
	return amount_paid
	
func set_price(new_amount_paid: float):
	price = new_amount_paid
	emit_signal("price_updated", price)  # Notify listeners

func get_price() -> float:
	return price
	
# For Giving Orders to Customers
func update_item_state(state: bool):
	has_item = state
	emit_signal("item_state_changed", state)  # Notify listeners
func get_item_state() -> bool:
	return has_item
