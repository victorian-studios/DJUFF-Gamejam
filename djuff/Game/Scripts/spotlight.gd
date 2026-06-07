extends Control

@onready var global

var trap_name
var cooldown_timer = false
var damage
var cooldown
var debuff_status
var debuff_value
var enemies_list = []
var work = false
var energy_value


func _ready():
	global = $"/root/Global"

	var status = global.read_json("spotlight", "res://Game/Jsons/traps.json")

	trap_name = status["name"]
	damage = status["strength"]
	cooldown = status["cooldown"]
	debuff_status = status["debuff"]["status"]
	debuff_value = status["debuff"]["value"]
	energy_value = status["energy_cost"]

	turn_on_or_off(energy_value)

func _process(delta):
	if work:
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("Monsters"):
				if enemies_list.find(body) == -1:
					body.speed = body.speed - ((body.speed * debuff_value) / 100)
					enemies_list.append(body)
					# shoot()

func turn_on_or_off(energy):
	if work == false:
		energy = energy * -1

	if get_parent().name == "MainGame":
		work = false
	else:
		work = get_parent().get_parent().get_parent().get_node("Home").update_energy(energy)

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Monsters") and work:
		if debuff_status == "speed":
			enemies_list.append(body)
			body.speed = body.speed - ((body.speed * debuff_value) / 100)



func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Monsters") and work:
		enemies_list.erase(body)
		body.speed = body.speed + ((body.speed * debuff_value) / 100)
