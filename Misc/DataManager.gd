extends Node

const file_name = "save.data"
var data = null

func load_game():
	var file = File.new()
	if file.file_exists("user://savegame.save"):
		file.open("user://savegame.save", File.READ)
		var text = file.get_as_text()
		data = parse_json(text)
		file.close()
	return data
		
func save_game(dict):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(dict))
	save_game.close()
