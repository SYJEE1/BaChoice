extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial quota from Global
	update_labels()  # Update labels to reflect initial values
	Global.connect("amount_paid_changed", Callable (self, "update_earnings"))
	Global.connect("new_stage_number", Callable (self, "update_stage"))
	

# Function to update earnings from Global
func update_earnings(total: float):
	total = Global.get_amount_paid()  # Retrieve the latest amount paid from Global
	update_labels()

func update_stage (new_stage: String):
	update_labels()
	
# Function to update the UI labels
func update_labels():
	$Quota.text = "%.2f" % Global.send_quota() # Display the Global quota
	$Earnings.text = "%.2f" % Global.get_amount_paid()  # Display the current earnings
	$Stage.text = "Stage " + str(Global.send_stage_num())  # Display the current earnings
	var recently_paid = Global.recent_amount
	$"../Earn".text = str(recently_paid)
	$"../Earn/downearn".play("kaching")
	
	
