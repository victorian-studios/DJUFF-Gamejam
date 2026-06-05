extends Control

var bullet = preload("res://Game/Scenes/Bullet.tscn")

@onready var global

var dir_left = true
var strength
var cooldown
var debuff
# var enemy
var enemies_list = []

func _ready():
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.offset = Vector2(0,0)
	global = $"/root/Global"

	var status = global.read_json("turret", "res://Game/Jsons/traps.json")

	strength = status["strength"]
	cooldown = status["cooldown"]
	debuff = status["debuff"]

	# await get_tree().create_timer(2).timeout
	# $AnimatedSprite2D.flip_h = true
	# $AnimatedSprite2D.offset = Vector2(120,0)



func _process(delta):
	if enemies_list != []:
		var enemy_global_position = -99999
		var index
		for enemy in enemies_list:
			if enemy.global_position.x > enemy_global_position:
				index = enemies_list.find(enemy)
				enemy_global_position = global_position.x
		if enemies_list[index].global_position.x > $Sprite2D/Center.global_position.x:
			dir_left = false
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.offset = Vector2(120,0)

		else:
			dir_left = true
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.offset = Vector2(0,0)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Monsters"):
		enemies_list.append(body)
		shoot()

func _on_area_2d_body_exited(body):
	enemies_list.erase(body)

func shoot():
	var bullet_child = bullet.instantiate()
	if dir_left:
		bullet_child.global_position = $AnimatedSprite2D/Left.global_position

		bullet_child.setup(-1, strength)
		get_parent().add_child(bullet_child)
	else:
		bullet_child.global_position = $AnimatedSprite2D/Right.global_position
		bullet_child.setup(1, strength)
		get_parent().add_child(bullet_child)

	$Cooldown.start(cooldown)
	

func _on_cooldown_timeout():
	if enemies_list != []:
		shoot()
