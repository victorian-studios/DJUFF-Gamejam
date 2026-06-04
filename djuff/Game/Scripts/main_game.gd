extends Node2D

@onready var animation
@onready var global
@onready var spawn
@onready var day_afternoon
@onready var night_day
@onready var hud_inventory

var waves
var day = 1

func _ready():
	$Item/AnimatedSprite2D.animation = "wood"
	$Item.setup($Item/AnimatedSprite2D.animation)
	$Item2/AnimatedSprite2D.animation = "screw"
	$Item2.setup($Item2/AnimatedSprite2D.animation)
	$Item3/AnimatedSprite2D.animation = "ingot"
	$Item3.setup($Item3/AnimatedSprite2D.animation)


	global = $"/root/Global"

	day_afternoon = $Timer1
	day_afternoon.start(global.day_time)
	night_day = $Timer2
	night_day.wait_time = global.night_time

	$DaysBG/BG_day.visible = true
	$DaysBG/BG_afternoon.visible = true
	$DaysBG/BG_night.visible = true

	animation = $AnimationPlayer
	animation.play("start_game")

	spawn = $Spawn

	waves = global.read_json("waves", "res://Game/Jsons/days_waves.json")

	hud_inventory = $HUD/Inventory/HBoxContainer

	# TIRAR DPS
	night(day)
	# get_tree().paused = true

func night(day):
	spawn.spawner(waves["day_"+str(day)])

func add_inventory(item):
	print(item.get_parent().item_name)
	var find_slot = false
	var selected

	for slot in hud_inventory.get_children():
		if slot.get_child(0).animation == "empty":
			find_slot = true
			slot.get_child(0).animation = item.get_parent().item_name
			break
		
		if slot.get_child(0).get_child(0).visible == true:
			selected = slot.get_child(0)
		
	if find_slot == false:
		selected.animation = item.get_parent().item_name
		
			# slot.get_child(0).animation = item
			
	# print(item.get_parent().item_name)
