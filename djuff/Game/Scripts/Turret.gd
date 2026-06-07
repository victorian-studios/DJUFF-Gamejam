extends Control

var bullet = preload("res://Game/Scenes/Bullet.tscn")

@onready var global

var trap_name
var dir_left = true
var strength
var cooldown
var debuff
var energy_value
# var enemy
var enemies_list = []
var work = false

# var areas = $Area2D.get_overlapping_areas()

func _ready():

	$SpotNumber.visible = false
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.offset = Vector2(0,0)
	global = $"/root/Global"

	var status = global.read_json("turret", "res://Game/Jsons/traps.json")

	trap_name = status["name"]
	strength = status["strength"]
	cooldown = status["cooldown"]
	debuff = status["debuff"]
	energy_value = status["energy_cost"]

	turn_on_or_off(energy_value)
	# await get_tree().create_timer(2).timeout
	# $AnimatedSprite2D.flip_h = true
	# $AnimatedSprite2D.offset = Vector2(120,0)

func _process(delta):
	if work:

		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("Monsters"):
				if enemies_list.find(body) == -1:
					enemies_list.append(body)
					shoot()


		if enemies_list != []:
			var enemy_global_position = -99999
			var index
			for enemy in enemies_list:
				if enemy:
					if enemy.global_position.x > enemy_global_position:
						index = enemies_list.find(enemy)
						enemy_global_position = global_position.x
				
			if index != null:
				if enemies_list[index].global_position.x > $Sprite2D/Center.global_position.x:
					dir_left = false
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.offset = Vector2(127,0)

				else:
					dir_left = true
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.offset = Vector2(0,0)

func turn_on_or_off(energy):
	if work == false:
		energy = energy * -1

	if get_parent().name == "MainGame":
		work = false
		# work = get_parent().get_node("Home").update_energy(energy)
	else:
		# print("AUDIHAISHAIUDHA", energy)
		work = get_parent().get_parent().get_parent().get_node("Home").update_energy(energy)
	# elif get_parent().get_parent().get_parent().get_node("Home") != null:
	# 	work = get_parent().get_parent().get_parent().get_node("Home").update_energy(energy)
	# else:
	# 	work = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("Monsters") and work:
		enemies_list.append(body)
		shoot()

func _on_area_2d_body_exited(body):
	if enemies_list and enemies_list.find(body) != -1:
		enemies_list.erase(body)

func shoot():
	if work:
		var bullet_child = bullet.instantiate()
		if dir_left:
			bullet_child.global_position = $AnimatedSprite2D/Left.global_position

			bullet_child.setup(-1, strength)
			
			var teste = get_parent().get_parent().get_parent()
			teste.add_child(bullet_child)
			
		else:
			bullet_child.global_position = $AnimatedSprite2D/Right.global_position
			bullet_child.setup(1, strength)
			var teste = get_parent().get_parent().get_parent()
			teste.add_child(bullet_child)

	$Cooldown.start(cooldown)
	

func _on_cooldown_timeout():
	if enemies_list != []:
		shoot()
