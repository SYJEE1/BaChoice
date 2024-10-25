extends Node2D

@onready var progress_bar: TextureProgressBar = $ProgressBar


func _ready() -> void:
	# wait time (seconds*2)
	progress_bar.max_value = 30


func _onTimeout() -> void:
	progress_bar.value += 1
	if progress_bar.value < progress_bar.max_value * 1.00: progress_bar.tint_progress = Color.LIGHT_GRAY
	elif progress_bar.value <= progress_bar.max_value * 1.20: progress_bar.tint_progress = Color.GREEN
	elif progress_bar.value <= progress_bar.max_value * 1.40: progress_bar.tint_progress = Color.YELLOW
	elif progress_bar.value <= progress_bar.max_value * 1.60: progress_bar.tint_progress = Color.ORANGE
	elif progress_bar.value <= progress_bar.max_value * 1.80: progress_bar.tint_progress = Color.RED
	elif progress_bar.value >= progress_bar.max_value * 2.20: 
		progress_bar.tint_progress = Color.BLACK
