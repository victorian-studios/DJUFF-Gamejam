extends Node2D

var total_energy
var global
var total_prices = []
var trap_complete
var energy

func _ready():
	$Panel/RichTextLabel.text = "[wave]E - View Shop[/wave]"

	$Panel/PanelImage.visible = false

	global = $"/root/Global"

	total_energy = global.traps_energy

	$Panel/RichTextLabel.visible = false

func update_energy(en_value):
	energy = get_parent().get_node("HUD").get_node("Energy")

	if energy.value == 0:
		if en_value < 0:
			print("1 ", energy.value," ",en_value)
			return false
		else:
			print("2 ", energy.value," ",en_value)
			return update_text_energy(en_value)
	else:
		if (energy.value + en_value) < 0:
			print("3 ", energy.value," ",en_value)
			return false
		else:
			print("4 ", energy.value," ",en_value)
			return update_text_energy(en_value)

	# if energy.value + en_value >= 0 and energy.value + en_value <= total_energy:
	# 	return update_text_energy(en_value)
	# else:
	# 	return false
	
	# if energy.value + en_value >= 0 and energy.value + en_value <= total_energy:
	# if energy.value == 0:
	# 	return false
	# elif energy.value + en_value < 0:
	# 	return false

	# elif energy.value + en_value > total_energy:
	# 	energy.value = total_energy
	# 	energy.get_node("EnergyCount").text = str(int(energy.value))+"/"+str(int(energy.max_value))
	# 	return false
	# else:
	# 	return update_text_energy(en_value)

	# if en_value < 0:
	# 	if energy.value + en_value < 0:
	# 		return false
	# 	else:
	# 		return update_text_energy(en_value)
	# else:
	# 	return update_text_energy(en_value)

func update_text_energy(en_value):
	# en_value = total_energy + en_value
	energy.value = energy.value + en_value
	print(energy.value,"\n************************************")
	if (energy.value + en_value) > total_energy:
		energy.value = total_energy
	energy.get_node("EnergyCount").text = str(int(energy.value))+"/"+str(int(energy.max_value))
	# return true
	
	if en_value < 0:
		return true
	else:
		return false

func set_panel_text(preparing_trap, price):
	if preparing_trap == true:
		total_prices = []
		var count = 0
		for item in $Panel/PanelImage.get_children():
			item.get_child(0).texture = load(price[count]["material"])
			item.get_child(1).text = "0 / "+str(int(price[count]["qtd"]))
			total_prices.append({"control": item, "name": price[count]["name"], "current_qtd": 0, "total_qtd": price[count]["qtd"]})
			count += 1

		trap_complete = total_prices.size()

		$Panel/PanelImage.visible = true
		$Panel/RichTextLabel.text = "[wave]E - Place Material[br]Q - Cancel Trap / Discard Materials[/wave]"

	else:
		$Panel/PanelImage.visible = false
		$Panel/RichTextLabel.text = "[wave]E - View Shop[/wave]"

func update_panel_text(item):
	for price in total_prices:
		if item == price["name"]:			

			if price["current_qtd"] + 1 == price["total_qtd"]:
				trap_complete -= 1
				price["control"].get_child(1).text = "Completed"
				price["current_qtd"] += 1
				if trap_complete == 0:
					set_panel_text(false, [])
					get_parent().get_node("HomePanel").preparing_trap = false

					var trap
					match global.chosen_trap:
						"Turret":
							trap = global.turret.instantiate()
							trap.global_position = get_parent().get_node("Player").global_position
							global.active_traps.append({"control_trap": trap})
							get_parent().add_child(trap)

						"Thorn":
							trap = global.thorn.instantiate()
							trap.global_position = get_parent().get_node("Player").global_position
							global.active_traps.append({"control_trap": trap})
							get_parent().add_child(trap)

						"Spotlight":
							trap = global.spotlight.instantiate()
							trap.global_position = get_parent().get_node("Player").global_position
							global.active_traps.append({"control_trap": trap})
							get_parent().add_child(trap)

				return false

			elif price["current_qtd"] == price["total_qtd"]:
				return true

			else:
				price["current_qtd"] += 1
				price["control"].get_child(1).text = str(int(price["current_qtd"]))+" / "+str(int(price["total_qtd"]))
				return false
