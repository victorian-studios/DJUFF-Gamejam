extends Node2D

@export var home_life = 5
@export var player_life = 1

@export var day_time = 10
@export var night_time = 8

@export var inventory_col_size = 3
# @export var inventory_list = []

func read_json(type, path):
	var file_json = FileAccess.open(path, FileAccess.READ)
	var content = file_json.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	
	if type == "werewolf":
		return json.data["normal"][type]
	
	elif type == "waves":
		return json.data
