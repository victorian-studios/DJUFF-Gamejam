extends Node2D

var total_energy
var global
var total_prices = []

func _ready():
	$Panel/RichTextLabel.text = "[wave]E - View Shop[/wave]"

	$Panel/PanelImage.visible = false

	global = $"/root/Global"

	total_energy = global.traps_energy

	$Panel/RichTextLabel.visible = false

func update_energy(value):
	if value <= total_energy:
		total_energy += value
		get_parent().get_node("HUD").get_node("Energy").value = total_energy
		$Energy/EnergyCount.text = str(int($Energy.value))+"/"+str(int($Energy.max_value))

	else:
		print("nao tem energia suficiente mona")
	# if total_energy +- value > 0:

func set_panel_text(preparing_trap, price):
	if preparing_trap == true:
		total_prices = []
		var count = 0
		for item in $Panel/PanelImage.get_children():
			item.get_child(0).texture = load(price[count]["material"])
			item.get_child(1).text = "0 / "+str(int(price[count]["qtd"]))
			print(price)
			total_prices.append({"control": item, "name": price[count]["name"], "current_qtd": 0, "total_qtd": price[count]["qtd"]})
			count += 1

		$Panel/PanelImage.visible = true
		$Panel/RichTextLabel.text = "[wave]E - Place Material[br]Q - Cancel Trap / Discard Materials[/wave]"

	else:
		$Panel/PanelImage.visible = false
		$Panel/RichTextLabel.text = "[wave]E - View Shop[/wave]"

func update_panel_text(item):
	for price in total_prices:
		if item == price["name"]:

			# if price["current_qtd"] < price["total_qtd"]:
			# 	price["current_qtd"] += 1
			# 	price["control"].get_child(1).text = str(int(price["current_qtd"]))+" / "+str(int(price["total_qtd"]))
			

			if price["current_qtd"] + 1 == price["total_qtd"]:
				print("ue")
				price["control"].get_child(1).text = "Completed"
				price["current_qtd"] += 1
				return false

			elif price["current_qtd"] == price["total_qtd"]:
				return true

			else:
				price["current_qtd"] += 1
				price["control"].get_child(1).text = str(int(price["current_qtd"]))+" / "+str(int(price["total_qtd"]))
				return false

			break
	pass
