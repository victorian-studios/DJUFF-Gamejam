extends Control

@onready var global

var trap_name
var cooldown_timer = false
var damage
var cooldown
var debuff
var enemies_list = []
var work = false
var energy_value


func _ready():
	global = $"/root/Global"

	var status = global.read_json("thorn", "res://Game/Jsons/traps.json")

	trap_name = status["name"]
	damage = status["strength"]
	cooldown = status["cooldown"]
	debuff = status["debuff"]
	energy_value = status["energy_cost"]

	turn_on_or_off(energy_value)

	
func turn_on_or_off(energy):
	if work == false:
		energy = energy * -1

	if get_parent().name == "MainGame":
		work = false
	else:
		work = get_parent().get_parent().get_parent().get_node("Home").update_energy(energy)


func _process(delta):
	if work:
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("Monsters"):
				if enemies_list.find(body) == -1:
					$Cooldown.start(cooldown)
					cooldown_timer = true
					enemies_list.append(body)

		if enemies_list != []:
			if cooldown_timer != true:
				for enemy in enemies_list:
					enemy.monster_take_damage($".")
				$Cooldown.start(cooldown)
				cooldown_timer = true
			# else:
			# 	damage = 0

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Monsters") and work:
		if enemies_list == []:
			# body.monster_take_damage($".")
			$Cooldown.start(cooldown)
			cooldown_timer = true
		enemies_list.append(body)


func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Monsters") and work:
		enemies_list.erase(body)

func _on_cooldown_timeout():
	cooldown_timer = false
