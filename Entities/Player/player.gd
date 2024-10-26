extends CharacterBody2D

# editable variables
var speed := 75
var accel := 5 
var detected_area = []
var exempted_area = []
#var detected_station = []
#var detected_item = []
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
			DialogueManager.show_example_dialogue_balloon(load("res://Non_Entity/Dialogue/tutorial.dialogue"), "start")
			game_running = true
			$"../HUD".get_node("Start").hide()
func interact(input_direction, delta) -> void:
	# print("detected Area:", detected_area)
	# print("exempted Area:", exempted_area)
	
	var debug = $DebugCircle
	debug.global_position = global_position
	
	
	#if detected_area.size() > 0 and detected_area[0].area_type == "station" == true and detected_area[0].takes_item == true: exempted_area.push_front(detected_area.pop_front())

	if has_item == false: # if no item
		speed = 70
		
		if detected_area.size() > 0:
			detected_area.sort_custom(_sort_by_distance_from_player)
			var nearest : Area2D = detected_area[0]
			debug.global_position = nearest.global_position
				
			if nearest.area_type == "countertop" or nearest.area_type == "stove" or nearest.area_type == "cuttingboard" or nearest.area_type == "ReceivingArea": 
				exempted_area.push_front(detected_area.pop_front())
				
			if nearest.area_type == "station":
				
				if nearest.has_method("glow") and nearest.takes_item == false: 
					nearest.glow(carried_item)
					
					if Input.is_action_just_pressed("interact"):
						PopSFX(1.30)
						carried_item = nearest.interact(carried_item)
						carried_item.pickup()
						carried_item.is_carried = true
						has_item = true
				
			if nearest.area_type == "item" and nearest.get_parent().is_carried == false:
				nearest.get_parent().glow()
				
				if Input.is_action_just_pressed("interact"):
					PopSFX(1.30)
					carried_item = nearest.get_parent()
					carried_item.pickup()
					carried_item.is_carried = true
					has_item = true
					detected_area.erase(nearest)
		

	else: # if has item 
		carried_item.global_position = lerp(carried_item.global_position, interact_collision.global_position, delta * accel * 3)
		speed = 50
		
		if detected_area.size() > 0:
			detected_area.sort_custom(_sort_by_distance_from_player)
			var nearest : Area2D = detected_area[0]
			debug.global_position = nearest.global_position
						
			if nearest.area_type == "item": # if holding an item, sees an item
				var nearest_item = nearest.get_parent().item_sprite
				# only pot and bowl goes through
				if nearest_item.animation not in ["pot"]: exempted_area.push_front(detected_area.pop_front())
				else:  # if empty BOWL and detects a ready POT 
					var item_type = carried_item.item_sprite
					var empty_bowl = (item_type.animation == "bowl" and (item_type .frame == 1 or item_type .frame == 70))
					var finished_pot = nearest_item.animation == "pot" and nearest_item.frame == 3
					var ready = nearest.get_parent().progress_bar.value >= nearest.get_parent().progress_bar.max_value
					if (empty_bowl and finished_pot) and ready == true:
						if Input.is_action_just_pressed("interact"):
							PopSFX(.70)
							nearest.get_parent().item_interact(carried_item)
							nearest.get_parent().find_bowl(carried_item, false)
							nearest.get_parent().reset()
								
					
					elif carried_item.item_sprite.animation == "pot" and (carried_item.item_sprite.animation in nearest.get_parent().possible_ingredients): 
						nearest.get_parent().glow()
					var item = carried_item.item_sprite.animation
					if Input.is_action_just_pressed("interact"):
						PopSFX(.70)
						nearest.get_parent().item_interact(carried_item)
						carried_item.is_carried = false
						carried_item = null 
						has_item = false
							
			if ((nearest.area_type == "station" or nearest.area_type == "cuttingboard" or nearest.area_type == "stove" or nearest.area_type == "ReceivingArea") and nearest.takes_item == true) or (nearest.area_type == "countertop"):
				if nearest.has_method("glow"): nearest.glow(carried_item)
			
				if Input.is_action_just_pressed("interact"):
					PopSFX(.70)
					detected_area.append(carried_item.get_child(0))
					carried_item.putdown()
					var distance = carried_item.global_position.distance_to(detected_area[0].global_position) * 20
					var impulse = carried_item.global_position.direction_to(detected_area[0].global_position) * distance
					carried_item.apply_impulse(impulse, Vector2(0,0))
					nearest.interact(carried_item)
					if carried_item.item_sprite.animation == "pot" and nearest.area_type == "stove":
						carried_item.toggle_onstove()
					
					carried_item.is_carried = false
					carried_item = null 
					has_item = false
					

func _sort_by_distance_from_player(area1, area2):
	var area1_to_player = interact_collision.global_position.distance_to(area1.global_position)
	var area2_to_player = interact_collision.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _on_itementered(area: Area2D) -> void: 
	if area in exempted_area: pass
	else: detected_area.push_back(area)
	
	if area.has_method("hotbar_peek"): area.hotbar_peek(true)

func _on_itemexited(area: Area2D) -> void: 
	if area in exempted_area: exempted_area.erase(area)
	detected_area.erase(area)
	if area.has_method("hotbar_peek"): area.hotbar_peek(false)
	
func PopSFX(pitch):
	$SFX/PopSound.pitch_scale = pitch
	$SFX/PopSound.play()
