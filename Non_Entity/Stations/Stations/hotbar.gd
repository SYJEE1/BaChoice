extends Node2D

@onready var hotbar_animation: AnimationPlayer = $HotbarAnimation

var selection: int = clampi(3,1,5)

func _ready() -> void:
	hotbar_animation.play("enter")	
	
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent):
	pass


func _on_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "exit": queue_free()
