extends Control

@onready var global

var cooldown_timer = false
var damage
var cooldown
var debuff_status
var debuff_value
var enemies_list = []


func _ready():
	global = $"/root/Global"

	var status = global.read_json("spotlight", "res://Game/Jsons/traps.json")

	damage = status["strength"]
	cooldown = status["cooldown"]
	print(status)
	debuff_status = status["debuff"]["status"]
	debuff_value = status["debuff"]["value"]

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Monsters"):
		if debuff_status == "speed":
			body.speed = body.speed - ((body.speed * debuff_value) / 100)



func _on_area_2d_body_exited(body: Node2D):
	body.speed = body.speed + ((body.speed * debuff_value) / 100)
