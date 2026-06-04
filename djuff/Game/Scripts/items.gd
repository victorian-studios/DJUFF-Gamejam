extends RigidBody2D

var player_in_area = false
@export var item_name = ""

func _ready():
	$Select.visible = false
	setup($AnimatedSprite2D.animation)

func setup(frame_name):
	item_name = frame_name


# func _process(delta):
# 	while player_in_area == true:
# 		$Select.visible = true

func _on_area_2d_body_exited(body: Node2D):
	player_in_area = false
	$Select.visible = false	

func _on_area_2d_body_entered(body: Node2D):
	player_in_area = true
	$Select.visible = true
