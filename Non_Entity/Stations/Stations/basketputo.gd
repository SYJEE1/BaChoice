extends Area2D

const area_type := &"station"
var takes_item: bool = true
var tilemap_glow : TileMapLayer
@onready var interact_collision: CollisionShape2D = $InteractCollision


func _ready() -> void:
	global_position += Vector2(0,-2)
	interact_collision.shape.size = Vector2(14,10)

func interact(carried_item) -> void:
	pass
