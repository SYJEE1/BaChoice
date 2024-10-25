extends Area2D

const area_type := &"station"
var takes_item: bool = false
var tilemap_glow : TileMapLayer
@onready var interact_collision: CollisionShape2D = $InteractCollision

const ITEM = preload("res://Non_Entity/Items/Item.tscn")

func _ready() -> void:
	global_position += Vector2(0,-1)
	interact_collision.shape.size = Vector2(12,8)
	tilemap_glow.modulate = Color(1,1,1,0)

func interact(carried_item):
	print("adding water item!")
	var instance = ITEM.instantiate()
	instance.global_position = global_position
	instance.set_item(&"water", 1)
	get_tree().root.add_child(instance)
	return instance
		
func glow(carried_item) -> void:
	var glow_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,1), .1)
	unglow(glow_tween)
	
func unglow(glow_tween) -> void:
	if glow_tween.finished:
		glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,0), .1)

func hotbar() -> void:
	pass
