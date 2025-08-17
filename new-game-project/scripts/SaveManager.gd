extends Node

const SAVE_PATH := "user://saves/save_file.json"

var save_data = {}

func save_game(player_position: Vector3, inventory: Dictionary, stats: Dictionary):
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	save_data = {
		"player_position": {
			"x": player_position.x,
			"y": player_position.y,
			"z": player_position.z
		},
		"inventory": inventory,
		"stats": stats
	}
	var json_string = JSON.new().stringify(save_data)
	file.store_string(json_string)
	file.close()

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var raw_text = file.get_as_text()
	file.close()

	var json = JSON.new()
