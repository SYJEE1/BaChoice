extends Node2D

@onready var progress_bar: TextureProgressBar = $ProgressBar

# Define the total duration for the progress bar
# The bar ticks once per second and fills over the customer's whole wait (see PATIENCE in customer.gd).
# The colours follow the pay tiers: green = full pay, yellow = 90%, orange = 80%, red = 70%.
const TOTAL_DURATION: float = 150.0
const GREEN_DURATION: float = 75.0
const YELLOW_DURATION: float = 25.0
const ORANGE_DURATION: float = 25.0
const RED_DURATION: float = 25.0

func _ready() -> void:
	# Set the maximum value of the progress bar
	progress_bar.max_value = TOTAL_DURATION
	progress_bar.value = 0  # Initialize the progress bar value

	# Start the timer (assuming you have a Timer node connected to _onTimeout)

func _onTimeout() -> void:
	# Increment the progress bar value
	progress_bar.value += 1

	# Determine the color based on the current value
	if progress_bar.value < GREEN_DURATION:
		progress_bar.tint_progress = Color.GREEN
	elif progress_bar.value < GREEN_DURATION + YELLOW_DURATION:
		progress_bar.tint_progress = Color.YELLOW
	elif progress_bar.value < GREEN_DURATION + YELLOW_DURATION + ORANGE_DURATION:
		progress_bar.tint_progress = Color.ORANGE
	elif progress_bar.value < TOTAL_DURATION:
		progress_bar.tint_progress = Color.RED
	else:
		progress_bar.tint_progress = Color.RED  # After 60 seconds, set to black or stop
