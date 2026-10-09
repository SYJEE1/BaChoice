extends Area2D

const area_type := &"ReceivingArea"
var takes_item: bool = true
var has_item = Global.get_item_state()  # Flag to track if the player is holding an item
var player_scene: PackedScene

var customer: CharacterBody2D
var collected_items: Dictionary = {
	"bowl": false,
	"drink": false,
	"sidedish": false
}
var order: Dictionary
const ITEM = preload("res://Non_Entity/Items/Item.tscn")

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	Global.connect("item_state_changed", Callable(self, "_on_item_state_changed"))
	var customer_node = get_parent()
	customer_node.connect("order_info_updated", Callable(self, "_get_order_info")) 
	global_position += Vector2(0, -15)

	
func interact(carried_item) -> void:
	pass

func _get_order_info(order_info) -> Dictionary:
	order = order_info
	return order

func _on_body_entered(carried_item: Node2D):
	if carried_item is RigidBody2D:
		var item = carried_item.item_sprite
		var item_anim = item.animation
		var item_frame = item.frame
		if not has_item:
			if item_anim == order["bowl"]["item_type"] and item_frame == order["bowl"]["bowl_index"]:
				collected_items["bowl"] = true
				if item.frame > 69:
					item.frame = 73
				else:
					item.frame = 4
			if item_anim == order["drink"]["item_type"] and  item_frame == order["drink"]["frame"]:
				collected_items["drink"] = true
				
			if item_anim == order["sidedish"]["item_type"] and item_frame == order["sidedish"]["frame"]:
				collected_items["sidedish"] = true
				
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
