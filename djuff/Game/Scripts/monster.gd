extends CharacterBody2D

var speed = 0
var life = 0
var strength = 0

# func _ready():
# 	setup("werewolf")

func setup(status):

	speed = status["speed"]
	life = status["life"]
	strength = status["strength"]
	$Monster_life.setMaxHearts(life)

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

func monster_take_damage(body):
	if life > 0:
			if life - body.damage > 0:
				life = life - body.damage
				$Monster_life.updateHearts(life)
			else:
				queue_free()

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Damage"):
		monster_take_damage(body)
		


func _on_area_2d_area_entered(area):
	if area.is_in_group("Damage") and area.get_parent().work:
		if life > 0:
			if life - (area.get_parent()).damage > 0:
				life = life - (area.get_parent()).damage
				$Monster_life.updateHearts(life)
			else:
				queue_free()
