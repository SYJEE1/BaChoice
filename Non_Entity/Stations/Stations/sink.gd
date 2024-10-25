extends Area2D

const area_type := "station"
var takes_item: bool = true
var tilemap_glow : TileMapLayer

@onready var interact_collision: CollisionShape2D = $InteractCollision

func _ready() -> void:
	#global_position += Vector2(0,-2)
	#interact_collision.shape.size = Vector2(14,10)
	tilemap_glow.modulate = Color(1,1,1,0)

func interact(carried_item) -> void:
	print("interact")
	var item = carried_item.item_sprite
	if item.animation == "bowl":
		if item.frame == 4: item.frame = 1
		if item.frame == 128: item.frame = 70


func glow(carried_item) -> void:
	var item = carried_item.item_sprite
	if item.animation == "bowl" and (item.frame == 4 or item.frame == 73):
		var glow_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,1), .1)
		unglow(glow_tween)
	
func unglow(glow_tween) -> void:
	if glow_tween.finished:
		glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,0), .1)
