extends CanvasLayer

var slot = preload("res://Game/Scenes/Slot.tscn")
var slot_list = []

func _ready():
	var global = $"/root/Global"
	for slot_count in range((global.inventory_col_size)):
		var inv_slot = slot.instantiate()
		inv_slot.get_node("Item").animation = "empty"
		$Inventory/HBoxContainer.add_child(inv_slot)
		if slot_count == 0:
			inv_slot.get_child(0).get_child(0).visible = true
		slot_list.append(inv_slot)
		# global.inventory_list.append(inv_slot)

func _process(delta):
	pass
