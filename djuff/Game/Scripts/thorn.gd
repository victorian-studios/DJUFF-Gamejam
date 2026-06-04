extends Control

@onready var global

var cooldown_timer = false
var damage
var cooldown
var debuff
var enemies_list = []


func _ready():
	global = $"/root/Global"

	var status = global.read_json("thorn", "res://Game/Jsons/traps.json")

	damage = status["strength"]
	cooldown = status["cooldown"]
	debuff = status["debuff"]

func _process(delta):
	if enemies_list != []:
		if cooldown_timer != true:
			for enemy in enemies_list:
				enemy.monster_take_damage($".")
			$Cooldown.start(cooldown)
			cooldown_timer = true
		# else:
		# 	damage = 0

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Monsters"):
		if enemies_list == []:
			body.monster_take_damage($".")
			$Cooldown.start(cooldown)
			cooldown_timer = true
		enemies_list.append(body)


func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("Monsters"):
		enemies_list.erase(body)

func _on_cooldown_timeout():
	cooldown_timer = false