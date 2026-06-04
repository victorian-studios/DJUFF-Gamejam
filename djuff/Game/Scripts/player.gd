extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -500.0

var hud

var current_slot
var new_slot
var can_interact = false
var item

func _ready():
	hud = get_parent().get_node("HUD")
	current_slot = hud.slot_list[0].get_child(0).get_child(0)
	# get_node("Inventory")

func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("interact") and can_interact:
		get_parent().add_inventory(item)
		# chamar o main game
		# chamar o hud
		# modificar a lista o.O
	
	if Input.is_action_just_pressed("slot_1"):
		print("slot 1")
		select_slot(1)

	if Input.is_action_just_pressed("slot_2"):
		print("slot 2")
		select_slot(2)
	
	if Input.is_action_just_pressed("slot_3"):
		print("slot 3")
		select_slot(3)

	move_and_slide()


func select_slot(number):
	new_slot = hud.slot_list[number-1].get_child(0).get_child(0)

	
	if new_slot != current_slot:
		current_slot.visible = !(current_slot.visible)
		new_slot.visible = !(new_slot.visible)
		current_slot = new_slot
	else:
		current_slot = new_slot
		# current_slot.visible = !(current_slot.visible)
		# new_slot.visible = !(new_slot.visible)

	# current_slot = 
	# current_slot.visible = !(current_slot.visible)


func _on_area_2d_area_entered(area):
	if area.is_in_group("Itens"):
		can_interact = true
		item = area

func _on_area_2d_area_exited(area):
	if area.is_in_group("Itens"):
		can_interact = false
