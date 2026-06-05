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
			trap_spot_child_number = 0
		if Input.is_action_just_pressed("trap_spot_2"):
			trap_spot_child_number = 1
		if Input.is_action_just_pressed("trap_spot_3"):
			trap_spot_child_number = 2
		if Input.is_action_just_pressed("trap_spot_4"):
			trap_spot_child_number = 3
		if Input.is_action_just_pressed("trap_spot_5"):
			trap_spot_child_number = 4
		if Input.is_action_just_pressed("trap_spot_6"):
			trap_spot_child_number = 5
		if Input.is_action_just_pressed("trap_spot_7"):
			trap_spot_child_number = 6
		if Input.is_action_just_pressed("trap_spot_8"):
			trap_spot_child_number = 7
		if Input.is_action_just_pressed("trap_spot_9"):
			trap_spot_child_number = 8
		
		var direction := Vector2.ZERO

		if Input.is_action_pressed("left"):
			direction.x -= 1
		if Input.is_action_pressed("right"):
			direction.x += 1

		position += direction.normalized() * speed * delta
