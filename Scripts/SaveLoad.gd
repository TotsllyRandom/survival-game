extends Node

func load_data():
	if !FileAccess.file_exists("user://save.json"):
		return
	
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()

	var json = JSON.new()

	if json.parse(text) == OK:
		var save = json.data
		pass

func save_data():
	var ret = {}
	ret["resources"] = Player.resources
	
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(ret))
	file.close()
