extends Marker2D

var werewolf = preload("res://Game/Scenes/Monster.tscn")

# [{ "qtd": 3.0, "enemy": "werewolf" }]
func spawner(enemies):
	var global = $"/root/Global"
	var status
	for enemy in enemies:
		for quantity in enemy["qtd"]:
			var enemy_child
			if enemy["enemy"] == "werewolf":
				enemy_child = werewolf.instantiate()
				status = global.read_json(enemy["enemy"], "res://Game/Jsons/enemies.json")
			
			enemy_child.global_position = position
			get_parent().add_child(enemy_child)
			enemy_child.setup(status)

			# TIRAR DPS
			await get_tree().create_timer(5).timeout

