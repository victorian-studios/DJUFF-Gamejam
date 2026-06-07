extends Panel

@onready var global
var shop_items
var shop_items_list = []
var shop_items_list_index = 0

var choosen_trap = {}
@export var preparing_trap = false

func _ready():
	global = $"/root/Global"
	var shop_items = global.read_json("all", "res://Game/Jsons/traps.json")
	for item in shop_items:
		shop_items_list.append(shop_items[item])
	
	update_shop(shop_items_list_index)

func update_shop(index):

	$ImageShop.texture = load(shop_items_list[index]["image"])

	var debuff = ""
	if shop_items_list[index]["debuff"] is String:
		debuff = "None"
	else:
		debuff = "Reduce " + shop_items_list[index]["debuff"]["status"]+" in "+str(int(shop_items_list[index]["debuff"]["value"]))+"%"

	$RichTextLabel.text = "Name: "+shop_items_list[index]["name"]+"[br]"+"Strength: "+str(shop_items_list[index]["strength"])+"[br]"+"Cooldown: "+str(shop_items_list[index]["cooldown"])+"[br]"+"Debuff: "+debuff

	var control_count = 1
	for price in shop_items_list[index]["price"]:
		var control = get_node(str(control_count))
		control.get_child(0).texture = load(price["material"])
		control.get_child(1).text = "X"+str(int(price["qtd"]))
		control_count += 1

	choosen_trap = shop_items_list[index]
	global.chosen_trap = shop_items_list[index]["name"]

func _on_close_pressed():
	get_parent().get_node("Player").can_control = true
	visible = false

func _on_right_shop_pressed():
	shop_items_list_index = shop_items_list_index + 1

	if shop_items_list_index > (shop_items_list.size() - 1):
		shop_items_list_index = 0

	update_shop(shop_items_list_index)

func _on_left_shop_pressed():
	shop_items_list_index = shop_items_list_index - 1
	
	if shop_items_list_index < 0:
		shop_items_list_index = (shop_items_list.size() - 1)

	update_shop(shop_items_list_index)

func _on_prepare_trap_pressed():
	preparing_trap = true
	visible = false
	get_parent().get_node("Player").can_control = true
	get_parent().get_node("Home").set_panel_text(preparing_trap, choosen_trap["price"])

func cancel_trap():
	preparing_trap = false
	get_parent().get_node("Home").set_panel_text(preparing_trap, [])