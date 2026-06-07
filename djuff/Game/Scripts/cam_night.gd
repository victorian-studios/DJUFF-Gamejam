extends Camera2D

@export var speed = 1500
var trap_spot_child_number

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enabled:
		if Input.is_action_just_pressed("trap_spot_1"):
			get_parent().turn_traps(1)
			# trap_spot_child_number = 0
		if Input.is_action_just_pressed("trap_spot_2"):
			get_parent().turn_traps(2)
			# trap_spot_child_number = 1
		if Input.is_action_just_pressed("trap_spot_3"):
			get_parent().turn_traps(3)
			# trap_spot_child_number = 2
		if Input.is_action_just_pressed("trap_spot_4"):
			get_parent().turn_traps(4)
			# trap_spot_child_number = 3
		if Input.is_action_just_pressed("trap_spot_5"):
			get_parent().turn_traps(5)
			# trap_spot_child_number = 4
		if Input.is_action_just_pressed("trap_spot_6"):
			get_parent().turn_traps(6)
			# trap_spot_child_number = 5
		if Input.is_action_just_pressed("trap_spot_7"):
			get_parent().turn_traps(7)
			# trap_spot_child_number = 6
		if Input.is_action_just_pressed("trap_spot_8"):
			get_parent().turn_traps(8)
			# trap_spot_child_number = 7
		if Input.is_action_just_pressed("trap_spot_9"):
			get_parent().turn_traps(9)
			# trap_spot_child_number = 8
		
		var direction := Vector2.ZERO

		if Input.is_action_pressed("left"):
			direction.x -= 1
		if Input.is_action_pressed("right"):
			direction.x += 1

		position += direction.normalized() * speed * delta
