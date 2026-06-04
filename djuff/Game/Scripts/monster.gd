extends CharacterBody2D

var speed = 0
var life = 0
var strength = 0

func _ready():
	setup("werewolf")

func setup(type):
	var global = $"/root/Global"
	var status = global.read_json("werewolf", "res://Game/Jsons/enemies.json")
	speed = status["speed"]
	life = status["life"]
	strength = status["strength"]

func _process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = 1

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
