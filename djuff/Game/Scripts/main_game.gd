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
	$HUD.change_hud(false)

	# get_tree().paused = true

func _process(delta):
	if day_afternoon.is_stopped() == false:
		if int(day_afternoon.time_left) == day_afternoon.wait_time / 2:
			animation.play("day_afternoon")

func night(day):
	$HUD.change_hud(true)
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

func remove_inventory(type):
	if type == "item":
		var total_slots = hud_inventory.get_child_count()
		var child_index = 0
		for slot in hud_inventory.get_children():
			if slot.get_child(0).get_child(0).visible == true:
				var completed = $Home.update_panel_text(slot.get_child(0).animation)

				if !(completed):
					slot.get_child(0).animation = "empty"
					slot.get_child(0).get_child(0).visible = false

					if child_index + 1 == total_slots:
						child_index = 0
					else:
						child_index += 1

					hud_inventory.get_child(child_index).get_child(0).get_child(0).visible = true
					$Player.current_slot = hud_inventory.get_child(child_index).get_child(0).get_child(0)
				break

			child_index += 1

func _on_day_afternoon_timeout():
	animation.play("afternoon_night")
	$Player/Camera2D.enabled = false
	$Player.global_position.x = $HomeNight.global_position.x
	$Player.can_control = false
	$CamNight.enabled = true
	night_day.start()
	night(day)
	configure_traps(true)
	$HomePanel.visible = false

func configure_traps(is_night):
	var spot_count = 0
	for spot in $AllTrapsSpots.get_children():
		spot_count += 1
		if spot.get_child_count() != 0:
			var trap = spot.get_child(0)
			trap.get_node("SpotNumber").visible = is_night
			trap.get_node("SpotNumber").text = str(spot_count)

func _on_night_timeout():
	$HUD.change_hud(false)
	animation.play("night_day")
	$Player/Camera2D.enabled = true
	$Player.can_control = true
	$CamNight.enabled = false
	configure_traps(false)

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "night_day":
		day_afternoon.start(global.day_time)
		
func open_house_panel(type):
	if $HomePanel.preparing_trap == false and type == "interact":
		$Player.can_control = false
		$HomePanel.visible = true
	
	if $HomePanel.preparing_trap == true:
		if type == "interact":			
			remove_inventory("item")


			# for slot in hud_inventory.get_children():
			# 	if slot.get_child(0).animation == "empty":
			# 		find_slot = true
			# 		slot.get_child(0).animation = item.get_parent().item_name
			# 		break
				
			# 	if slot.get_child(0).get_child(0).visible == true:
			# 		selected = slot.get_child(0)
				
			# if find_slot == false:
			# 	selected.animation = item.get_parent().item_name

		elif type == "cancel":
			$HomePanel.cancel_trap()
