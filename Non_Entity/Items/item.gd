extends RigidBody2D

# func find_bowl_algo(code:String) -> int: 
# find bowl algo tutorial

# Input (B)asic or (S)uper
# Input #if 1:Empty 2:Broth 3:Overcooked 4:DirtyDishes 5:Noodles :)

# if you input 5:Noodles you can:
# Input 6:Miswa 7:Bihon 8:Sotanghon 9:Miki

# then Input toppings (E)gg (P)ork (L)iver (C)hicharon

# examples:
# S3 = Super Bowl, Overcooked
# R58EPL = Regular, Sotanghon with Egg, Pork and Liver

@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_collision: CollisionShape2D = $PickupArea/PickupCollision
@onready var item_shadow: AnimatedSprite2D = $ItemShadow
@onready var item_glow: AnimatedSprite2D = $ItemGlow

@onready var glow_animation: AnimationPlayer = $GlowAnimation
@onready var item_sprite: AnimatedSprite2D = $ItemSprite
@onready var item_animation: AnimationPlayer = $ItemAnimation
@onready var effects: Sprite2D = $ItemSprite/Effects
@onready var progress_bar: TextureProgressBar = $ItemSprite/ProgressBar
@onready var cook_timer: Timer = $ItemSprite/InsidePot/CookTimer
@onready var inside_pot: Sprite2D = $ItemSprite/InsidePot

@onready var effects_animation: AnimationPlayer = $ItemSprite/EffectsAnimation
@onready var fire: Sprite2D = $ItemSprite/Fire


const sprite_frames = preload("res://Non_Entity/Items/Item.tres")
@export var custom_item_type: StringName
@export var custom_frame: int = 1

var is_carried := false
var noodles = []
var possible_ingredients = ["raw_cut_liver", "raw_cut_pork", "egg", "broth", "miswa", "bihon", "sotanghon", "miki"]
var pot_array = []
var on_stove := false
var burnt := false

func _ready() -> void:
	if custom_item_type: item_sprite.animation = custom_item_type
	if custom_frame: item_sprite.frame = custom_frame
	set_item(item_sprite.animation, item_sprite.frame)
	
	progress_bar.value = 0 
	item_glow.play("unglow")
	fire.get_child(0).play("RESET")
	effects_animation.play("insidepot_exit")
	$ItemSprite/InsidePot.visible = true
	on_stove = false
	update_pot()
	
	
func set_item(animation, frame) -> void:
	var item_shadow: AnimatedSprite2D = $ItemShadow
	var item_glow: AnimatedSprite2D = $ItemGlow
	var item_sprite: AnimatedSprite2D = $ItemSprite
	
	item_sprite.sprite_frames = sprite_frames
	item_sprite.animation = animation
	item_sprite.frame = frame
	
	item_glow.sprite_frames = item_sprite.sprite_frames
	item_glow.animation = item_sprite.animation
	if animation != "bowl": item_glow.frame = frame - 1
	elif frame <= 69: item_glow.frame = 0
	else: item_glow.frame = 70
	
	item_shadow.sprite_frames = item_sprite.sprite_frames
	item_shadow.animation = item_sprite.animation
	item_shadow.frame = item_sprite.frame

func glow(time:int = 1) -> void:
	glow_animation.play("glow")
	if item_sprite.animation == "pot" and pot_array.size() > 0:
		effects_animation.play("insidepot_enter")
		await get_tree().create_timer(time).timeout
		effects_animation.queue("insidepot_exit")
	glow_animation.queue("unglow")
	
func unglow() -> void:
	if glow_animation.animation_finished:
		glow_animation.play("unglow")	

func can_put_in_pot(item_type): 
	if (item_type in possible_ingredients) and (item_type not in pot_array): return true
	
func direct_interact(item_type: String) -> void:
	to_pot_array(item_type) # send to pot_array7
	
func item_interact(item_carried) -> void:
	var item_type = item_carried.item_sprite.animation
	update_pot()
	if can_put_in_pot(item_type) == true:
		# item transfer animation start
		item_carried.item_animation.play("into_pot")
		set_item("pot", 1)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(item_carried, "global1_position", global_position, .5)
		await get_tree().create_timer(.5).timeout
		item_carried.queue_free()
		# item transfer animation end
		
		to_pot_array(item_type) # send to pot_array
	
func to_pot_array(item_type: String) -> void:
	if can_put_in_pot(item_type) == true:
		print("putting in pot: ", item_type)
		
		 # transfer said item from possible_ingredients to pot_array
		var noodles = ["miswa", "bihon", "sotanghon", "miki"]
		if item_type in noodles:  # erase all possible noodles
				possible_ingredients.erase("miswa")
				possible_ingredients.erase("bihon")
				possible_ingredients.erase("sotanghon")
				possible_ingredients.erase("miki")
				pot_array.push_back(item_type)
		else:
			pot_array.push_back(item_type)
			possible_ingredients.erase(item_type)
		
		# update InsidePot visibility by item_type
		if item_type == "broth": $ItemSprite/InsidePot.texture.region = Rect2(240,176,48,32)
		if item_type == "raw_cut_liver": $ItemSprite/InsidePot/Liver.visible = true
		if item_type == "raw_cut_pork": $ItemSprite/InsidePot/Pork.visible = true
		if item_type == "egg": $ItemSprite/InsidePot/Egg.visible = true
		if item_type in noodles: 
			$ItemSprite/InsidePot/Noodle.visible = true
			$ItemSprite/InsidePot/Noodle.animation = item_type
			$ItemSprite/InsidePot/Noodle.frame = 1
		
		
		# every item added updates overcook_point = 10 times pot array.size + current value for balancing
		if progress_bar.value < progress_bar.max_value:
			progress_bar.max_value = 10 * pot_array.size() #+ (progress_bar.value / 3)
		
		if pot_array.size() > 0: item_sprite.frame = 3
		print("Pot_array: ",pot_array)
		update_pot()
		
	else: 
		print("ERROR. Cannot put ", item_type, "in pot array: ", pot_array)
		breakpoint

func toggle_onstove():
	on_stove = !on_stove
	await get_tree().create_timer(.5).timeout
	update_pot()

func update_pot() -> void:
	# on stove, fire animation
	var noodle_check : bool = ("miswa" in pot_array) or ("bihon" in pot_array) or ("sotanghon" in pot_array) or ("miki" in pot_array)
	if ((on_stove == true) and ("broth" in pot_array)) and noodle_check == true and burnt == false:
		cook_timer.paused = false
		progress_bar.visible = true
		fire.get_child(0).play("fire")
		fire.get_child(1).emitting = true
		$SFX/BoiledPot.play()
	else: 
		cook_timer.paused = true
		fire.get_child(0).play("nofire")
		fire.get_child(1).emitting = false
		$SFX/BoiledPot.stop()
	
	
	
		
	
		
func pickup() -> void:
	on_stove = false
	update_pot()
	item_animation.play("pickup")
	is_carried = true

func putdown() -> void:
	item_animation.play("putdown")
	is_carried = false

func dead() -> void:
	queue_free()

func reset() -> void:
	progress_bar.value = 0
	progress_bar.visible = false
	
	set_item("pot", 1)
	pot_array.clear()
	
	$ItemSprite/InsidePot/Liver.visible = false
	$ItemSprite/InsidePot/Pork.visible = false
	$ItemSprite/InsidePot/Egg.visible = false
	$ItemSprite/InsidePot/Noodle.visible = false
	$ItemSprite/InsidePot.texture.region = Rect2(192,176,48,32)
	
	$ItemSprite/Fire/Overcooked.emitting = false
	$ItemSprite/Fire/Burnt.emitting = false
	update_pot()
	
	progress_bar.value = 0 
	item_glow.play("unglow")
	fire.get_child(0).play("RESET")
	effects_animation.play("insidepot_exit")
	$ItemSprite/InsidePot.visible = true
	on_stove = false
	update_pot()

func _on_cook_timer_timeout() -> void:
	if burnt == false:
		progress_bar.value += 1
		if progress_bar.value < progress_bar.max_value * 1.00: progress_bar.tint_progress = Color.LIGHT_GRAY
		elif progress_bar.value <= progress_bar.max_value * 1.20: progress_bar.tint_progress = Color.GREEN
		elif progress_bar.value <= progress_bar.max_value * 1.40: progress_bar.tint_progress = Color.YELLOW
		elif progress_bar.value <= progress_bar.max_value * 1.60: progress_bar.tint_progress = Color.ORANGE
		elif progress_bar.value <= progress_bar.max_value * 1.80: progress_bar.tint_progress = Color.RED
		elif progress_bar.value >= progress_bar.max_value * 2.20: 
			burnt = true
			$SFX/Burnt.play()
			$ItemSprite/Fire/Overcooked.emitting = true
			$ItemSprite/Fire/Burnt.emitting = true
			progress_bar.tint_progress = Color.BLACK
			$ItemSprite/InsidePot.texture.region = Rect2(288,176,48,32)
			update_pot()
	

func find_bowl(item_carried, burnt: bool):
	var bowl_index = 0
	
	# Super or Large
	if item_carried.item_sprite.animation == "bowl": 
		if item_carried.item_sprite.frame > 69: bowl_index += 69
		else: bowl_index += 0
	else: 
		print("not a bowl, is ", item_carried.item_sprite.animation, " instead" )
		
	
	if burnt == true: bowl_index += 3; return bowl_index
	
	var toppings = []
	for x in pot_array:
		print(x)
		if x == "miswa": bowl_index += 0
		if x == "bihon": bowl_index += 16
		if x == "sotanghon": bowl_index += 32
		if x == "miki": bowl_index += 48
		
		# if (E)gg (P)ork (L)iver (C)hicharon
		if x == "egg": toppings.append("E")
		if x == "raw_cut_pork": toppings.append("P")
		if x == "raw_cut_liver": toppings.append("L")
		if x == "chicharon": toppings.append("C")
	print("toppings: ", toppings)
	if toppings != []:
		if toppings == []: bowl_index += 0
		elif toppings == ["E"]: bowl_index += 1
		elif toppings == ["P"]: bowl_index += 2
		elif toppings == ["L"]: bowl_index += 3
		elif toppings == ["C"]: bowl_index += 4
		elif toppings == ["E","P"]: bowl_index += 5
		elif toppings == ["P","C"]: bowl_index += 6
		elif toppings == ["P","L"]: bowl_index += 7
		elif toppings == ["E","L"]: bowl_index += 8
		elif toppings == ["L","C"]: bowl_index += 9
		elif toppings == ["E","C"]: bowl_index += 10
		elif toppings == ["E","P","L"]: bowl_index += 11
		elif toppings == ["P","L","C"]: bowl_index += 12
		elif toppings == ["E","L","C"]: bowl_index += 13
		elif toppings == ["E","P","C",]: bowl_index += 14
		elif toppings == ["E","P","L","C"]: bowl_index += 15 
		else: print("error bowl code"); breakpoint
			
			
	
	print("final bowl index: ", bowl_index)
	#item_carried.set_item("bowl", bowl_index)
	item_carried.set_item("bowl", bowl_index)
