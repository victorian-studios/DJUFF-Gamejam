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
	$HomePanel.visible = false

	$CamNight.enabled = false

	$Item/AnimatedSprite2D.animation = "wood"
	$Item.setup($Item/AnimatedSprite2D.animation)
	$Item2/AnimatedSprite2D.animation = "screw"
	$Item2.setup($Item2/AnimatedSprite2D.animation)
	$Item3/AnimatedSprite2D.animation = "ingot"
	$Item3.setup($Item3/AnimatedSprite2D.animation)


	global = $"/root/Global"

	day_afternoon = $DayAfternoon
	day_afternoon.start(global.day_time)
	night_day = $Night
	night_day.wait_time = global.night_time

	$DaysBG/BG_day.visible = true
	$DaysBG/BG_afternoon.visible = true
	$DaysBG/BG_night.visible = true

	animation = $AnimationPlayer
	animation.play("start_game")

	spawn = $Spawn

	waves = global.read_json("waves", "res://Game/Jsons/days_waves.json")

	hud_inventory = $HUD/Inventory/HBoxContainer

	# get_tree().paused = true

func _process(delta):
	if day_afternoon.is_stopped() == false:
		if int(day_afternoon.time_left) == day_afternoon.wait_time / 2:
			animation.play("day_afternoon")

func night(day):
	spawn.spawner(waves["day_"+str(day)])

func add_inventory(item):
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

func _on_day_afternoon_timeout():
	animation.play("afternoon_night")
	$Player/Camera2D.enabled = false
	$Player.global_position.x = $HomeNight.global_position.x
	$Player.can_control = false
	$CamNight.enabled = true
	night_day.start()
	night(day)

func _on_night_timeout():
	animation.play("night_day")
	$Player/Camera2D.enabled = true
	$Player.can_control = true
	$CamNight.enabled = false

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "night_day":
		day_afternoon.start(global.day_time)
		
func open_house_panel():
	$Player.can_control = false
	$HomePanel.visible = true
