extends Node2D

@onready var animation
@onready var global
@onready var spawn
@onready var day_afternoon
@onready var night_day
@onready var hud_inventory

var audio_day = "res://Game/Musics and Sounds/nature_ambience_by_u_vr5icvkppa.mp3"
var audio_night = "res://Game/Musics and Sounds/halloween_by_the_mountain.mp3"
var audio_werewolf = "res://Game/Musics and Sounds/wolf_howl_by_freesound_community.mp3"

var current_trap

var spots_dict = {}

var waves
var day = 1

var enemies_list = []

func _ready():
	$Music.volume_db = -10
	$Music.stream = load(audio_day)
	$Music.play()
	get_tree().paused = false
	print("new game")
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
	$HUD.get_node("Energy").max_value = global.traps_energy

	var spots_count = 1
	for spot in $AllTrapsSpots.get_children():
		spot.spot_number = spots_count
		spot.get_node("SpotNumber").text = "[wave]"+str(int(spot.spot_number))+"[/wave]"
		spot.get_node("OnOff").animation = "empty"

		if spot.get_child_count() > 4: #MUDAR
			for spots_child in spot.get_children():
				if spots_child is Control and !(spots_child is RichTextLabel):
					if spots_child.work == true:
						spot.get_node("OnOff").animation = "on"
						spot.get_node("SpotTip").animation = "spot_full"
					
					else:
						spot.get_node("OnOff").animation = "off"
						spot.get_node("SpotTip").animation = "spot_empty"
		
		spots_dict[spot.spot_number] = spot
		spots_count += 1

	# get_tree().paused = true

func _process(delta):
	if day_afternoon.is_stopped() == false:
		if int(day_afternoon.time_left) == day_afternoon.wait_time / 2:
			animation.play("day_afternoon")
		if Input.is_action_just_pressed("skip_day"):
			day_afternoon.stop()
			$DaysBG/BG_day.visible = false
			_on_day_afternoon_timeout()
	
	if night_day.is_stopped() == false:
		# print(enemies_list)
		if enemies_list == []:
			night_day.stop()
			_on_night_timeout()
		# if enemies_list == []:

	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !(get_tree().paused)
		$HUD/Screens.visible = !($HUD/Screens.visible)
		$HUD/Screens/GameOver.visible = !($HUD/Screens/GameOver.visible)
		$HUD/Screens/Pause.visible = !($HUD/Screens/Pause.visible)
	# $Screens.visible = false
	# $Screens/GameOver.visible = false
	# $Screens/Pause.visible = false


func night(day):
	$HUD.change_hud(true)

	for spot in $AllTrapsSpots.get_children():
		for spots_child in spot.get_children():
			if spots_child is Control and !(spots_child is RichTextLabel):
				if spots_child.work == true:
					spot.get_node("OnOff").get_node("PointLight2D").enabled = true

	spawn.spawner(waves["day_"+str(day)])

func add_inventory(item):
		var find_slot = false
		var selected

		for slot in hud_inventory.get_children():
			if slot.get_child(0).animation == "empty":
				find_slot = true

				if item.is_in_group("Traps"):
					if item.get_parent().get_parent() is Marker2D:
						item.get_parent().get_parent().get_node("SpotTip").animation = "spot_empty"
						item.get_parent().get_parent().get_node("OnOff").animation = "empty"
						# print()
						item.get_parent().work = $Home.update_energy(item.get_parent().energy_value)
					# if item.get_parent().get_parent() is Marker2D:
					# 	item.get_parent().get_parent().remove_child(item.get_parent())
					# 	item.get_parent().get_parent().get_node()

					# global.active_traps[global.active_traps.find(item.get_parent())]

					if global.active_traps.find({"control_trap": item.get_parent()}) < 0:
						global.active_traps.append({"control_trap":item.get_parent()})

					# var teste = 
					item.get_parent().reparent($".")
					
					(global.active_traps[global.active_traps.find({"control_trap": item.get_parent()})])["control_slot"] = slot

					slot.get_child(0).animation = item.get_parent().trap_name

					item.get_parent().visible = false
					# item.monitorable = false
					item.get_parent().process_mode = Node.PROCESS_MODE_DISABLED
				
				elif item.is_in_group("Items"):
					slot.get_child(0).animation = item.get_parent().item_name
				break
			
			if slot.get_child(0).get_child(0).visible == true:
				selected = slot.get_child(0)
			
		if find_slot == false:
			if item.is_in_group("Traps"):
				print("tirei rs")
				selected.animation = item.get_parent().trap_name
			
			elif item.is_in_group("Items"):
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
					if slot.get_child(0).animation != "Spotlight" and slot.get_child(0).animation != "Turret" and slot.get_child(0).animation != "Thorn" :
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

	elif type == "trapspot":

		if $Player.current_slot.get_parent().animation == "Turret" or $Player.current_slot.get_parent().animation == "Thorn" or $Player.current_slot.get_parent().animation == "Spotlight":

			# for slot in hud_inventory.get_children():
			# 	if slot.get_child(0).get_child(0).visible == true:
			# 		$Player.current_slot = slot.get_child(0).get_child(0)
				
			# print($Player.current_slot.get_parent().get_parent(), global.active_traps)
			# print(global.active_traps.find({"control_slot": $Player.current_slot.get_parent().get_parent(), "control_trap"}))

			var control_trap

			for dict in global.active_traps:
				if dict["control_slot"] == $Player.current_slot.get_parent().get_parent():
					control_trap = dict["control_trap"]

			$Player.current_slot.get_parent().animation = "empty"

			# var control_trap = global.active_traps[global.active_traps.find({"control_slot": $Player.current_slot.get_parent().get_parent()})]["control_trap"]

			# print(control_trap)

			var teste = $Player.item.get_parent()

			control_trap.reparent(teste)
			
			var teste2 = control_trap.energy_value * -1

			control_trap.work = $Home.update_energy(teste2)

			if control_trap.work == true:
				teste.get_node("OnOff").animation = "on"
			else:
				teste.get_node("OnOff").animation = "off"
				
			teste.get_node("SpotTip").animation = "spot_full"

			control_trap.global_position = $Player.item.get_parent().global_position
			# print($Player.item.get_parent().global_position, control_trap.global_position)

			# if !(control_trap.global_position == $Player.item.get_parent().global_position):
			# 	control_trap.global_position = $Player.item.get_parent().global_position
			control_trap.position.y = -180.0
			
			# print($Player.item.get_parent())

			control_trap.process_mode = Node.PROCESS_MODE_ALWAYS
			control_trap.visible = true
			

			# if global.active_traps.find({"control_slot": $Player.current_slot.get_parent().get_parent()}) < 0:
			# 	print()

			# print(global.active_traps)
			
			# print($Player.item, " ", $Player.current_slot)

		# else:
		# 	pass

func _on_day_afternoon_timeout():
	$Music.stream = load(audio_werewolf)
	$Music.play()
	# animation.play("day_afternoon")
	animation.play("afternoon_night")
	$Player/Camera2D.enabled = false
	$Player.global_position.x = $HomeNight.global_position.x
	$Player.can_control = false
	$CamNight.enabled = true
	night_day.start()
	night(day)
	# configure_traps(true)
	$HomePanel.visible = false

func _on_night_timeout():
	
	$Music.volume_db = -10
	$Music.stream = load(audio_day)
	$Music.play()
	for spot in $AllTrapsSpots.get_children():
		for spots_child in spot.get_children():
			if spots_child is Control and !(spots_child is RichTextLabel):
				if spots_child.work == true:
					spot.get_node("OnOff").get_node("PointLight2D").enabled = false

	$HUD.change_hud(false)
	animation.play("night_day")
	$Player/Camera2D.enabled = true
	$Player.can_control = true
	$CamNight.enabled = false
	# configure_traps(false)
	
	day += 1
	if day == 7:
		get_tree().paused = true
		$HUD/Screens.visible = true
		$HUD/Screens/GameOver.visible = false
		$HUD/Screens/Pause.visible = false
		$HUD/Screens/Victory.visible = true

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

func turn_traps(spot_number):
	var choosen_spot = spots_dict.get(spot_number)
	
	if choosen_spot.get_child_count() < 5: #MUDAR
		# print("NAO TEM ARMADILHA AQUI MERMAO")
		return false
	else:
		for spots_child in choosen_spot.get_children():
			if spots_child is Control and !(spots_child is RichTextLabel) :
				# print(choosen_spot, spots_child)
				var teste = spots_child.energy_value
				current_trap = spots_child
				if spots_child.work == false:
					teste = spots_child.energy_value * -1
				# print(spots_child.work)
				spots_child.work = get_node("Home").update_energy(teste)
				if spots_child.work == true:
					choosen_spot.get_node("OnOff").animation = "on"
					choosen_spot.get_node("OnOff").get_node("PointLight2D").enabled = true
				else:
					choosen_spot.get_node("OnOff").animation = "off"
					choosen_spot.get_node("OnOff").get_node("PointLight2D").enabled = false
				# print(spots_child.work)
				return spots_child.work

func game_over():
	$HUD/Screens.visible = true
	$HUD/Screens/GameOver.visible = true
	$HUD/Screens/Pause.visible = false
	get_tree().paused = true


func _on_music_finished():
	if $Music.stream == preload("res://Game/Musics and Sounds/wolf_howl_by_freesound_community.mp3"):
		$Music.volume_db = -25
		$Music.stream = load(audio_night)
		$Music.play()