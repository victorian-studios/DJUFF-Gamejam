extends RigidBody2D

var speed = 500
var dir = 0
@export var damage = 0

func setup(direction, strength):
	dir = direction
	damage = strength

func _physics_process(delta):
	linear_velocity.x = dir * speed

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Monsters"):
		queue_free()

