extends CharacterBody2D

# editable variables
var speed := 75
var accel := 5 
var detected_area = []
var game_running : bool
# node paths
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $PlayerSprite/AnimationPlayer
@onready var carried_item: RigidBody2D

# interact variables
var has_item : bool
@onready var interact_area: Area2D = $InteractArea
@onready var interact_collision: CollisionShape2D = $InteractArea/InteractCollision

# this functions runs once 
func _ready() -> void:
	animation_player.play("idle_down")
	if self.has_node("Item") == false:
		has_item = false
		interact_collision.disabled = false
	else: 
		has_item = true
		interact_collision.disabled = true
		#Global.connect("new_dialogue", Callable(self, "get_dialogue"))
		#Global.send_dialogue
# this functions runs every frame
func _physics_process(delta: float) -> void:
	
	# gets input within the 4 axis (-x, +x, -y, +y)
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# movement formula
	movement(input_direction, delta)
	
	#interact
	interact(input_direction, delta)
	
	# when colliding with another collision, player slides.
	move_and_slide()
	
	
func movement(input_direction, delta) -> void:
	if game_running:
		# movement smoothness formula
		velocity = lerp(velocity, input_direction * speed, delta * accel)

		# do this if player stops moving
		if input_direction == Vector2.ZERO:
			velocity = lerp(velocity, Vector2.ZERO, delta * accel) # apply friction
			animation_player.speed_scale = lerp(animation_player.speed_scale, 1.0, delta* accel)
			if animation_player.current_animation == "walk_left": animation_player.play("idle_left")
			elif animation_player.current_animation == "walk_right": animation_player.play("idle_right")
			elif animation_player.current_animation == "walk_up": animation_player.play("idle_up")
			elif animation_player.current_animation == "walk_down": animation_player.play("idle_down")

		else: # if player is moving
			if abs(input_direction.x) > abs(input_direction.y):
				if input_direction.x > 0: animation_player.play("walk_right")
				else: animation_player.play("walk_left")
			elif abs(input_direction.x) < abs(input_direction.y):
				if input_direction.y > 0: animation_player.play("walk_down") 
				else: animation_player.play("walk_up")
			
			# speeds animation via velocity
			animation_player.speed_scale = (( abs(velocity.x) + abs(velocity.y)) /30)
			
			# moves interact_collision (purple thing) based on movement
			if (input_direction.x > .501 or input_direction.x < -.5) or (input_direction.y > .501 or input_direction.y < -.5): 
				interact_collision.position = lerp(interact_collision.position, Vector2(
				input_direction.x * 6, 
				input_direction.y * 4), 
				delta * accel * 5)
	else:
		if Input.is_action_just_pressed("interact"):
			#var dialogue_path = Global.stage1_dialogue
			#DialogueManager.show_example_dialogue_balloon(load("res://Non_Entity/Dialogue/tutorial.dialogue"), "start")
			game_running = true
			Global.game_running = true
			$"../HUD".get_node("Start").hide()
func interact(input_direction, delta) -> void:
	# forget anything that has been freed since last frame (items put in a pot or in the trash)
	detected_area = detected_area.filter(func(area): return is_instance_valid(area))
	if has_item and not is_instance_valid(carried_item):
		carried_item = null
		has_item = false

	if has_item == false: # if no item
		speed = 70
		var target : Area2D = _nearest_area(_usable_empty_handed)
		if target == null: return

		if target.area_type == "item":
			var item = target.get_parent()
			item.glow()
			if Input.is_action_just_pressed("interact"):
				PopSFX(1.30)
				_hold(item)
		else: # a station that hands out items
			target.glow(carried_item)
			if Input.is_action_just_pressed("interact"):
				PopSFX(1.30)
				_hold(target.interact(carried_item))

	else: # if has item
		carried_item.global_position = lerp(carried_item.global_position, interact_collision.global_position, delta * accel * 3)
		speed = 50
		var target : Area2D = _nearest_area(_usable_with_item)
		if target == null: return

		if target.area_type == "item": # the only items that matter while carrying are pots
			var pot = target.get_parent()
			if _can_scoop_from(pot): # empty BOWL and a ready POT: fill the bowl and keep holding it
				if Input.is_action_just_pressed("interact"):
					PopSFX(.70)
					pot.find_bowl(carried_item, pot.burnt)
					pot.reset()
			else: # an ingredient this pot can still take
				pot.glow()
				if Input.is_action_just_pressed("interact"):
					PopSFX(.70)
					pot.item_interact(carried_item)
					_let_go()
		else: # a station or countertop to put the item on
			if target.has_method("glow"): target.glow(carried_item)
			if Input.is_action_just_pressed("interact"):
				PopSFX(.70)
				carried_item.putdown()
				var distance = carried_item.global_position.distance_to(target.global_position) * 20
				var impulse = carried_item.global_position.direction_to(target.global_position) * distance
				carried_item.apply_impulse(impulse, Vector2(0,0))
				target.interact(carried_item)
				if carried_item.item_sprite.animation == "pot" and target.area_type == "stove":
					carried_item.toggle_onstove()
				_let_go()

func _hold(item) -> void:
	carried_item = item
	carried_item.pickup()
	carried_item.is_carried = true
	has_item = true

func _let_go() -> void:
	carried_item.is_carried = false
	carried_item = null
	has_item = false

# what the player can use with empty hands: loose items, and stations that hand out items
func _usable_empty_handed(area) -> bool:
	if area.area_type == "item":
		return area.get_parent().is_carried == false
	return area.area_type == "station" and area.takes_item == false and area.has_method("glow")

# what the player can use while carrying: a pot that wants the item (or can fill the bowl),
# stations that take items, and countertops
func _usable_with_item(area) -> bool:
	if area.area_type == "item":
		var item = area.get_parent()
		if item == carried_item or item.item_sprite.animation != "pot": return false
		return _can_scoop_from(item) or item.can_put_in_pot(carried_item.item_sprite.animation) == true
	if area.area_type == "countertop": return true
	var takes_items = area.area_type == "station" or area.area_type == "cuttingboard" or area.area_type == "stove" or area.area_type == "ReceivingArea"
	return takes_items and area.takes_item == true

func _can_scoop_from(pot) -> bool:
	var bowl = carried_item.item_sprite
	var empty_bowl = bowl.animation == "bowl" and (bowl.frame == 1 or bowl.frame == 70)
	var finished_pot = pot.item_sprite.animation == "pot" and pot.item_sprite.frame == 3
	var ready = pot.progress_bar.value >= pot.progress_bar.max_value
	return empty_bowl and finished_pot and ready

func _nearest_area(usable: Callable) -> Area2D:
	var nearest : Area2D = null
	var nearest_distance := INF
	for area in detected_area:
		if not usable.call(area): continue
		var distance = interact_collision.global_position.distance_to(area.global_position)
		if distance < nearest_distance:
			nearest = area
			nearest_distance = distance
	return nearest

func _on_itementered(area: Area2D) -> void:
	if area not in detected_area: detected_area.push_back(area)
	if area.has_method("hotbar_peek"): area.hotbar_peek(true)

func _on_itemexited(area: Area2D) -> void:
	detected_area.erase(area)
	if area.has_method("hotbar_peek"): area.hotbar_peek(false)

func PopSFX(pitch):
	$SFX/PopSound.pitch_scale = pitch
	$SFX/PopSound.play()
