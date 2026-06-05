extends Node2D

@export var home_life = 5
@export var player_life = 1

@export var day_time = 40
@export var night_time = 10

@export var inventory_col_size = 3

@export var traps_energy = 3

func convert_json(path):
	var file_json = FileAccess.open(path, FileAccess.READ)
	var content = file_json.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	return json

func read_json(type, path):
	if type == "all":
		var json = convert_json(path)
		return json.data

	else:	
		var json = convert_json(path)
		
		if type == "werewolf":
			return json.data["normal"][type]
		
		elif type == "waves":
			return json.data
		
		elif type == "turret" or type == "thorn" or type == "spotlight":
			return json.data[type]
