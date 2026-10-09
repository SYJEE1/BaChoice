extends Node2D

# Preload assets with their prices
var bowl = {
	"Bowl1": {"texture": preload("res://Entities/Customer/Order/ingredients/bowl-regular.png"), "price": 50, "item_type": "bowl", "bowl_index": 69, "required" : true},
	"Bowl2": {"texture": preload("res://Entities/Customer/Order/ingredients/bowl-super.png"), "price": 60, "item_type": "bowl", "bowl_index": 0, "required" : true}
}
var noodles = {
	"NoodleType1": {"texture": preload("res://Entities/Customer/Order/ingredients/miki.png"), "price": 20, "bowl_index": 48},
	"NoodleType2": {"texture": preload("res://Entities/Customer/Order/ingredients/miswa.png"), "price": 20, "bowl_index": 0},
	"NoodleType3": {"texture": preload("res://Entities/Customer/Order/ingredients/sotanghon.png"), "price": 20, "bowl_index": 32},
	"NoodleType4": {"texture": preload("res://Entities/Customer/Order/ingredients/bihon.png"), "price": 20, "bowl_index": 16}
}
var toppings = {
	"Topping1": {"texture": preload("res://Entities/Customer/Order/ingredients/egg.png"), "price": 10 },
	"Topping2": {"texture": preload("res://Entities/Customer/Order/ingredients/pork.png"), "price": 10},
	"Topping3": {"texture": preload("res://Entities/Customer/Order/ingredients/liver.png"), "price": 10},
	#"Topping4": {"texture": preload("res://Entities/Customer/Order/ingredients/chicharon-temp.png"), "price": 10}
}
var drinks = {
	"Drink1": {"texture": preload("res://Entities/Customer/Order/ingredients/water.png"), "price": 10, "item_type": "water", "frame": 1, "required" : true},
	"Drink2": {"texture": preload("res://Entities/Customer/Order/ingredients/cora.png"), "price": 20, "item_type": "cora", "frame": 1, "required" : true},
	"Drink3": {"texture": preload("res://Entities/Customer/Order/ingredients/sprike.png"), "price": 20, "item_type": "sprike", "frame": 1, "required" : true},
	"Drink4": {"texture": preload("res://Entities/Customer/Order/ingredients/loyal.png"), "price": 20, "item_type": "loyal", "frame": 1, "required" : true},
	"Drink5": {"texture": preload("res://Entities/Customer/Order/ingredients/c3.png"), "price": 15, "item_type": "c3", "frame": 1, "required" : true}
}
var sidedish = {
	"Sidedish1": {"texture": preload("res://Entities/Customer/Order/ingredients/puto.png"), "price": 20, "item_type": "puto", "frame": 1, "required" : true},
	"Sidedish2": {"texture": preload("res://Entities/Customer/Order/ingredients/pandesal.png"), "price": 20, "item_type": "pandesal", "frame": 1, "required" : true}
}
var combined_info = {
		"bowl": {"item_type": "", "bowl_index": 0, "required" : false},
		"drink": {"item_type": "", "frame": 0, "required" : false},
		"sidedish": {"item_type": "", "frame": 0, "required" : false}
	}
# Nodes
@onready var vbox_container= get_node("Control/VBoxContainer")
var order_function_name: String = ""

func _ready():
	var order_function_name = Global.send_order() 
	var order = call(order_function_name)
	var total_price = calculate_total_price(order)
	var bowl_info = find_bowl_index(order)
	var combined_order_info = combined_order_info(order)
	display_order(order)
	
func tutorial() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[0]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	for topping_choice in topping_keys:
		order[topping_choice] = topping_choice
		chosen_toppings.append(topping_choice)
		
	return order
func stage1_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[0]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	return order
func stage2_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[0]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage3_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 2]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage4_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 2]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage5_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 3]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage6_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 3]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key

	return order
func stage7_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 3]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key
	
	var sidedish_keys = sidedish.keys()
	order["Sidedish"] = sidedish_keys[0]

	return order
func stage8_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % noodle_keys.size()]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key
	
	var sidedish_keys = sidedish.keys()
	order["Sidedish"] = sidedish_keys[0]

	return order
func stage9_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % noodle_keys.size()]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key
	
	var sidedish_keys = sidedish.keys()
	order["Sidedish"] = sidedish_keys[randi() % sidedish_keys.size()]

	return order
func display_order(order: Dictionary):
	# Clear previous order display
	var children = vbox_container.get_children()
	for child in children:
		child.queue_free()
	
	# Initialize the first HBoxContainer
	var hbox_container = HBoxContainer.new()
	var addtl_hbox = HBoxContainer.new()
	hbox_container.z_index = 2
	addtl_hbox.z_index = 2
	var sprite_count = 0
	var total_sprites = 0
	
	var bg_3 = TextureRect.new()
	var bg_4 = TextureRect.new()
	var bg_5up = TextureRect.new()
	
	bg_3.texture = preload("res://Entities/Customer/Order/bg-3.png") 
	bg_4.texture = preload("res://Entities/Customer/Order/bg-4.png") 
	bg_5up.texture = preload("res://Entities/Customer/Order/bg-5up.png")
	
	bg_3.position = Vector2(0, 0)
	bg_4.position = Vector2(0, 0)
	bg_5up.position = Vector2(0, 0)
	
	bg_3.z_index = 1
	bg_4.z_index = 1
	bg_5up.z_index = 1
	
	bg_3.scale = Vector2(1.5, 1.5)
	bg_4.scale = Vector2(1.5, 1.5)
	bg_5up.scale = Vector2(1.5, 1.5)
	
	# Display bowl
	if order.has("Bowl"):
		var bowl_key = order["Bowl"]
		var bowl_sprite = TextureRect.new()
		bowl_sprite.texture = bowl[bowl_key]["texture"]  # Access the texture
		bowl_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		bowl_sprite.position = Vector2(5, 5)  # Position for bowl
		hbox_container.add_child(bowl_sprite)
		sprite_count += 1  # Increment sprite count
		total_sprites += 1

	# Display noodle
	if order.has("Noodle"):
		var noodle_key = order["Noodle"]
		var noodle_sprite = TextureRect.new()
		noodle_sprite.texture = noodles[noodle_key]["texture"]  # Access the texture
		noodle_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		noodle_sprite.position = Vector2(16, 0)  # Position for noodle
		hbox_container.add_child(noodle_sprite)
		sprite_count += 1  # Increment sprite count
		total_sprites += 1

	# Display each topping
	for topping in order.keys():
		if topping.begins_with("Topping"):
			var topping_x = 32  # Starting x position for toppings
			var topping_count = 0  # Count the number of toppings
			topping_count += 1 
			topping_x += (topping_count - 1) * 16 
			var topping_sprite = TextureRect.new()
			topping_sprite.texture = toppings[topping]["texture"]  # Access the texture
			topping_sprite.scale = Vector2(1, 1)  # Set size to match the asset
			topping_sprite.position = Vector2(topping_x, 5)  # Centered in the background
			total_sprites += 1
			if total_sprites < 5:
				hbox_container.add_child(topping_sprite)
			else:
				# Create a new HBoxContainer for the next row
				addtl_hbox.add_child(topping_sprite)
				sprite_count = 1  # Reset sprite count
			topping_x -= 20  # Decrement x position for next topping (20 for spacing)

	# Display drink
	if order.has("Drink"):
		var drink_key = order["Drink"]
		var drink_sprite = TextureRect.new()
		drink_sprite.texture = drinks[drink_key]["texture"]  # Access the texture
		drink_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		drink_sprite.position = Vector2(5, 40)  # Position for drink
		total_sprites += 1
		if total_sprites < 5:
			hbox_container.add_child(drink_sprite)
		else:
			# Create a new HBoxContainer for the next row
			addtl_hbox.add_child(drink_sprite)

	if order.has("Sidedish"):
		var sidedish_key = order["Sidedish"]
		var sidedish_sprite = TextureRect.new()
		sidedish_sprite.texture = sidedish[sidedish_key]["texture"]  # Access the texture
		sidedish_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		sidedish_sprite.position = Vector2(5, 40)  # Position for drink
		total_sprites += 1
		if total_sprites < 5:
			hbox_container.add_child(sidedish_sprite)
			sprite_count += 1  # Increment sprite count
		else:
			# Create a new HBoxContainer for the next row
			addtl_hbox.add_child(sidedish_sprite)
			sprite_count = 1  # Reset sprite count
			
	var bg_checker = total_sprites
	
	if bg_checker == 3:
		add_child(bg_3)
	elif bg_checker == 4:
		add_child(bg_4)
	elif bg_checker > 4:
		add_child(bg_5up)
		
	vbox_container.add_child(hbox_container)
	vbox_container.add_child(addtl_hbox)
func calculate_total_price(order: Dictionary) -> float:
	var total: float = 0.0
	
	# Calculate the total price based on the order
	if order.has("Bowl"):
		var bowl_key = order["Bowl"]
		total += bowl[bowl_key]["price"]  # Access the price

	if order.has("Noodle"):
		var noodle_key = order["Noodle"]
		total += noodles[noodle_key]["price"]  # Access the price

	# Calculate total for toppings
	for topping in order.keys():
		if topping.begins_with("Topping"):
			total += toppings[topping]["price"]  # Access the price

	if order.has("Drink"):
		var drink_key = order["Drink"]
		total += drinks[drink_key]["price"]  # Access the price
		
	if order.has("Sidedish"):
		var sidedish_key = order["Sidedish"]
		total += sidedish[sidedish_key]["price"]  # Access the price
	return total
func find_bowl_index(order: Dictionary) -> int:
	var bowl_index = 0
	
	if order.has("Bowl"):
		var bowl_key = order["Bowl"]
		bowl_index += bowl[bowl_key]["bowl_index"] 

	if order.has("Noodle"):
		var noodle_key = order["Noodle"]
		bowl_index += noodles[noodle_key]["bowl_index"] 

	# Calculate total for toppings
	# Mapping for topping keys to their corresponding values
	var topping_mapping = {
		"Topping1": "E", 
		"Topping2": "P", 
		"Topping3": "L",  
		"Topping4": "C"   
	}

	# Collect unique toppings
	var toppings_set = PackedStringArray()

	for topping_key in order.keys():
		if topping_key.begins_with("Topping"):
			if topping_mapping.has(topping_key):
				var topping_value = topping_mapping[topping_key]
				toppings_set.append(topping_value)  # Add the topping to the set

	toppings_set.sort()
	# Sort the combined toppings to ensure consistent ordering
	var toppings_array = Array(toppings_set)  # Convert to Array
	var combined_toppings: String = ""
	for topping in toppings_array:
		combined_toppings += topping  # Concatenate toppings toppings into a string
		
	# Use a mapping to determine the bowl index for the combined toppings
	var toppings_index_mapping = {
		"": 0,
		"E": 1,
		"P": 2,
		"L": 3,
		"C": 4,
		"EP": 5,
		"CP": 6,
		"LP": 7,
		"EL": 8,
		"CL": 9,
		"CE": 10,
		"ELP": 11,
		"CLP": 12,
		"CEL": 13,
		"CEP": 14,
		"CELP": 15
	}

	# Add the topping bowl index to the total bowl index
	if toppings_index_mapping.has(combined_toppings):
		bowl_index += toppings_index_mapping[combined_toppings]
	else:
		push_error("Invalid topping combination: ", combined_toppings)
	bowl_index += 5
	return bowl_index

func combined_order_info(order: Dictionary) -> Dictionary:
	var bowl_index = find_bowl_index(order)
	combined_info["bowl"]["bowl_index"] = bowl_index  
	
	if order.has("Bowl"):
		var bowl_key = order["Bowl"]
		if bowl.has(bowl_key):
			combined_info["bowl"]["item_type"] = bowl[bowl_key]["item_type"]
			combined_info["bowl"]["required"] = bowl[bowl_key]["required"]
	if order.has("Drink"):
		var drinks_key = order["Drink"]
		if drinks.has(drinks_key):
			combined_info["drink"]["item_type"] = drinks[drinks_key]["item_type"]
			combined_info["drink"]["frame"] = drinks[drinks_key]["frame"]
			combined_info["drink"]["required"] = drinks[drinks_key]["required"]
	if order.has("Sidedish"):
		var sidedish_key = order["Sidedish"]
		if sidedish.has(sidedish_key):
			combined_info["sidedish"]["item_type"] = sidedish[sidedish_key]["item_type"]
			combined_info["sidedish"]["frame"] = sidedish[sidedish_key]["frame"]
			combined_info["sidedish"]["required"] = sidedish[sidedish_key]["required"]
	return combined_info
