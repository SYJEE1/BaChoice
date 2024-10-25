extends Area2D

const area_type := &"ReceivingArea"

var has_item = Global.get_item_state()  # Flag to track if the player is holding an item
var player_scene: PackedScene

var customer: CharacterBody2D
var collected_items: Dictionary = {
	"bowl": false,
	"drink": false,
	"sidedish": false
}
var order: Variant = { "bowl": { "item_type": "bowl", "bowl_index": 122, "required": true }, "drink": { "item_type": "", "frame": 0, "required": false }, "sidedish": { "item_type": "", "frame": 0, "required": false } }

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	Global.connect("item_state_changed", Callable(self, "_on_item_state_changed"))
	
func interact(carried_item) -> void:
	pass
	
func _on_body_entered(carried_item: RigidBody2D):	
	if carried_item is RigidBody2D:
		var item_type = carried_item.custom_item_type
		var item_frame = carried_item.custom_frame
		if not has_item:
			if item_type == order["bowl"]["item_type"] and item_frame == order["bowl"]["bowl_index"]:
				collected_items["bowl"] = true
				if item_frame > 69:
					carried_item.custom_frame = 73
				else:
					carried_item.custom_frame = 3
					
				print("Bowl collected.")
				print("Bowl frame is now: ", carried_item.custom_frame)
				
			if item_type == order["drink"]["item_type"] and not "" and  item_frame == order["drink"]["frame"]:
				collected_items["drink"] = true
				print("Drink collected.")
			if item_type == order["sidedish"]["item_type"] and not "" and item_frame == order["sidedish"]["frame"]:
				collected_items["Sidedish"] = true
				print("Side dish collected.")
				
			if not (order["bowl"]["required"] or order["drink"]["required"] or order["sidedish"]["required"]):
				print("No items required for this order.")
			else:
				print("Player is holding an incorrect item: ", carried_item.custom_item_type, carried_item.custom_frame)
			if all_items_collected():
				get_parent().finish_order()
				
func _on_item_state_changed(state: bool):
	has_item = state  # Update the has_item state based on the player's signal

func all_items_collected() -> bool:
	var all_collected = true

	if order["bowl"]["required"]:
		all_collected = all_collected and collected_items["bowl"]
	
	if order["drink"]["required"]:
		all_collected = all_collected and collected_items["drink"]
	
	if order["sidedish"]["required"]:
		all_collected = all_collected and collected_items["sidedish"]

	return all_collected
